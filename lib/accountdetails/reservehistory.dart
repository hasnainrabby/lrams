import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';



late Map mapResponse;
late List listResponse;
bool isLoading = false;
final df = new  DateFormat.yMMMMd();
class ReserveHistory extends StatefulWidget {
  const ReserveHistory({Key? key}) : super(key: key);

  @override
  State<ReserveHistory> createState() => _ReserveHistoryState();
}

class _ReserveHistoryState extends State<ReserveHistory> {
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
        Uri.parse('https://library.parliament.gov.bd:8080/api/profile/summary/reserve/history'),
    headers: {'Authorization': 'Bearer $token'}); //Enter Real Url.
    if (response.statusCode == 200) {

      mapResponse = json.decode(response.body);
      listResponse = mapResponse['data']['reserves'];  //add reserve from api
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
          title: Text('Reserve History',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
          centerTitle: true,
        ),
        body: Column(
          children: [
            !isLoading?
            Expanded(
              child: ListView.builder(itemBuilder: (context,index){
                return Container(
                  child: Card(
                    elevation: 5,
                    color: Colors.green.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Text('ID:'+listResponse[index]['id'].toString(),
                                style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),

                              Text('Bibliographic ID:'+listResponse[index]['bibliographic_id'].toString(),
                                style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                            ],
                          ),

                          Row(
                            children: [
                              Text('Bibliographic Copy ID:'+listResponse[index]['bibilographic_copy_id'].toString(),
                                style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                            ],
                          ),
                          Text('Created:'+ df.format(DateTime.parse((listResponse[index]['created_at']))),
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),
                        Text('Updated:'+ df.format(DateTime.parse((listResponse[index]['updated_at']))),
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),


                        ],
                      ),
                    ),
                  ),
                );
              },
                itemCount: listResponse ==null? 0: listResponse.length,),
            ): Padding(
              padding: const EdgeInsets.all(150.0),
              child: Center(child: CircularProgressIndicator(color: Colors.green,)),
            )
          ],
        ));
  }
}
