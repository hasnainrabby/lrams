import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

//Hasnain Rabby. Date:15/02/23

  Map mapResponse = {};
  Map dataResponse = {};
bool isLoading = false;
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String token = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = Provider.of<AuthProvider>(context).token;
    apicall();
  }

  Future apicall() async {
    setState(() {
      isLoading = true;
    });
    final token = Provider.of<AuthProvider>(context).token;
    Response response;
    response = await get(
      Uri.parse('https://library.parliament.gov.bd:8080/api/profile/summary/show'),
      headers: {'Authorization': 'Bearer $token'},
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      dataResponse = mapResponse['data']['user'];

    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Profile',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            !isLoading ?
                
            Center(
              child: ListView(
                     padding: EdgeInsets.all(10.0),
                     shrinkWrap: true,
                     children: [
                       AnimatedTextKit(animatedTexts: [
                         TyperAnimatedText('   Library Research and Archive Management System',textStyle: TextStyle(
                             fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Montserrat',color: Colors.green
                         ) ),
                       ],
                         isRepeatingAnimation: true,
                         totalRepeatCount: 20,),
                         Divider(thickness: 0.8,),
                         //dataResponse!= null ? Container():
                             Container(
                         alignment: Alignment.center,
                         child: ClipOval(
                         child: FadeInImage(
                         placeholder: AssetImage('assets/images/placeholder.png'),
                         image: NetworkImage(dataResponse['avatar']),
                         fit: BoxFit.cover,
                         width: 120,
                         height: 120,
                           imageErrorBuilder: (context, error, stackTrace) {
                             return Image.asset(
                               'assets/images/placeholder.png',
                               fit: BoxFit.cover,
                               width: 120,
                               height: 120,
                             );
                           },),

                             ),),
                             //Image(image: dataResponse['avatar']),
                            // Image.network(dataResponse['avatar']),
                       Divider(
                         thickness: 0.8,
                       ),
                       Card(
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                         elevation: 5,
                         color: Colors.green.shade100,
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               SizedBox(
                                 height: 5,
                               ),
                               Text('User ID : ${dataResponse['id']}' ,
                                 style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                               Divider(thickness: 0.0,),

                               Text('Name : ${dataResponse['name']}',
                                 style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),

                               Divider(thickness: 0.0,),
                               Text('Email : ${dataResponse['email']} ' ,
                                 style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),

                               Divider(thickness: 0.0,),
                               Text('Phone : ${dataResponse['phone']}' ,
                                 style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                               Divider(thickness: 0.0,),
                               Text('Gender : ${dataResponse['gender']} ',
                                 style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                               Divider(thickness: 0.0,),
                               Text('Address : ${dataResponse['address']}',
                                 style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                               SizedBox(
                                 height: 5,
                               ),
                             ],
                           ),
                         ),
                       )

                     ],
                ),
            ):
                Padding(
                  padding: const EdgeInsets.only(top: 250.0),
                  child: Center(child:
                  CircularProgressIndicator(color: Colors.green)),
                ),
          ],
        ),
      ),
      );
  }
}
