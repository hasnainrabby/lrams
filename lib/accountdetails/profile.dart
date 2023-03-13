import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

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
                         dataResponse!= null ? Container():
                            // Image(image: dataResponse['avatar']),
                             Image.network(dataResponse['avatar']),
                       Divider(
                         thickness: 0.8,
                       ),
                       Text('Id : ${dataResponse['id']}' ,
                         style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                       Divider(
                         thickness: 0.8,
                       ),
                         Text('Name : ${dataResponse['name']}',
                           style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                         Divider(
                           thickness: 0.8,
                         ),
                         Text('Email : ${dataResponse['email']} ' ,
                           style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                       Divider(
                         thickness: 0.8,
                       ),
                       Text('Phone : ${dataResponse['phone']}' ,
                         style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                       Divider(
                         thickness: 0.8,
                       ),
                       Text('Gender :${dataResponse['gender']} ',
                         style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                       Divider(
                         thickness: 0.8,
                       ),
                       Text('Address : ${dataResponse['address']}',
                         style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
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
