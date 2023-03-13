import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../../auth_provider.dart';


late Map mapResponse;
late List listResponse;
bool isLoading = false;
class Damage extends StatefulWidget {
  const Damage({Key? key}) : super(key: key);

  @override
  State<Damage> createState() => _DamageState();
}

class _DamageState extends State<Damage> {
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
        Uri.parse('https://library.parliament.gov.bd:8080/api/profile/summary/fines/damage_lost/history'),
        headers: {'Authorization': 'Bearer $token'}); //Enter Real Url. its demo.
    if (response.statusCode == 200) {

      mapResponse = json.decode(response.body);
      listResponse = mapResponse['data']['fines'];
    }
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Damage & Losts',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
          centerTitle: true,
        ),
        body: Column(
          children: [
            !isLoading?
            Expanded(
              child: ListView.builder(itemBuilder: (context,index){
                return Container(
                  child: Column(
                    children: [
                      Text('ID :'+listResponse[index]['id'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),
                      Text('Bibliographic Copy ID :'+listResponse[index]['bibilographic_copy_id'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),
                      Text('Damage Type ID :'+listResponse[index]['damage_type_id'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),
                      Text('Responsible For :'+listResponse[index]['responsible_for'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),

                      Text('Return Date :'+listResponse[index]['return_date'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),
                      Text('Return :'+listResponse[index]['is_return'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),
                      Text('Credit :'+listResponse[index]['credit'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),
                      Text('Debit :'+listResponse[index]['debit'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),
                      Text('Description :'+listResponse[index]['description'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),
                      Text('Fine Clear :'+listResponse[index]['is_fine_clear'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),
                    ],
                  ),
                );
              },
                itemCount: listResponse ==null? 0: listResponse.length,),
            ) :Padding(
              padding: const EdgeInsets.all(150.0),
              child: Center(child: CircularProgressIndicator(color: Colors.green)),
            )
          ],
        ));
  }
}