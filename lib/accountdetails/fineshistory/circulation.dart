import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../auth_provider.dart';

final df = new  DateFormat.yMMMMd();
bool isLoading = false;
late Map mapResponse;
late List listResponse = [];

class Circulation extends StatefulWidget {
  const Circulation({Key? key}) : super(key: key);

  @override
  State<Circulation> createState() => _CirculationState();
}

class _CirculationState extends State<Circulation> {
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
        Uri.parse('https://library.parliament.gov.bd:8080/api/profile/summary/fines/circulation/history'),
        headers: {'Authorization': 'Bearer $token'}); //Enter Real Url. its demo.
    if (response.statusCode == 150) {

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
          title: Text('Circulation',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
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
                        children: [
                          Row(
                            children: [
                              Text('BG ID:'+listResponse[index]['bibliographic_id'].toString(),
                                style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),

                              Text('BG Copy ID:'+listResponse[index]['bibilographic_copy_id'].toString(),
                                style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Credit:'+listResponse[index]['credit'].toString(),
                                style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),
                             
                              Text('Debit:'+listResponse[index]['debit'].toString(),
                                style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),
                              
                              Text('Fine Clear:'+listResponse[index]['fine_clear'].toString(),
                                style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),
                             
                            ],
                          ),
                          Text('Loan Date:'+df.format(DateTime.parse((listResponse[index]['loan_date']))),
                            style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),
                         
                          Text('Due Date:'+df.format(DateTime.parse((listResponse[index]['due_date']))),
                            style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),
                         
                          Text('Return Date:'+df.format(DateTime.parse((listResponse[index]['return_date']))),
                            style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),
                         Row(
                           children: [
                             Text('Return:'+listResponse[index]['is_return'].toString(),
                               style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),


                             Text('Status:'+listResponse[index]['status'].toString(),
                               style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),

                             Text('Renew:'+listResponse[index]['renew'].toString(),
                               style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),
                           ],
                         ),
                          Row(
                            children: [
                              Text('Discount Percentage:'+listResponse[index]['discount_percentage'].toString(),
                                style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),

                              Text('Discount Percentage:'+listResponse[index]['discount_percentage'].toString(),
                                style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.w500),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
                itemCount: listResponse ==null? 0: listResponse.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,),
            )
                : Padding(
              padding: const EdgeInsets.all(150.0),
              child: Center(child: CircularProgressIndicator(color: Colors.green,)),
            )
          ],
        ));
  }
}
