import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

class currentLoanHistory extends StatefulWidget {
  const currentLoanHistory({Key? key}) : super(key: key);

  @override
  State<currentLoanHistory> createState() => _currentLoanHistoryState();
}

class _currentLoanHistoryState extends State<currentLoanHistory> {
  late Map mapResponse;
  late Map dataResponse;
  late List listResponse = [];
  bool isLoading = true;
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
       Uri.parse('https://library.parliament.gov.bd:8080/api/profile/summary/currenloans/history'),
      headers: {
        'Authorization': 'Bearer $token'
      },); //Real Url.
    if (response.statusCode == 200) {

      Map<String, dynamic> mapResponse = json.decode(response.body);
      dataResponse = mapResponse;
      listResponse = dataResponse['data']['loans'];
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
        title: Text('Current Loan History',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
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
          Text('User ID :'+listResponse[index]['id'].toString(),
          style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
          Divider(
          thickness: 0.8,
          ),
            Text('Bibliographic ID :'+listResponse[index]['bibliographic_id'].toString(),
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
            Divider(
              thickness: 0.8,
            ),
            Text('Bibliographic Copy ID :'+listResponse[index]['bibilographic_copy_id'].toString(),
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
            Divider(
              thickness: 0.8,
            ),
          Text('Loan Date :'+listResponse[index]['loan_date'].toString(),
          style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
          Divider(
          thickness: 0.8,
          ),
          Text('Due Date :'+listResponse[index]['due_date'].toString(),
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
          Text('Fine Clear :'+listResponse[index]['fine_clear'].toString(),
          style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
          Divider(
          thickness: 0.8,
          ),
          Text('Status :'+listResponse[index]['status'].toString(),
          style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
          Divider(
          thickness: 0.8,
          ),
            Text('Taken By :'+listResponse[index]['taken_by'].toString(),
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
            Divider(
              thickness: 0.8,
            ),

          Text('Renew :'+listResponse[index]['renew'].toString(),
          style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
          Divider(
          thickness: 0.8,
          ),
          Text('Discount Percentage :'+listResponse[index]['discount_percentage'].toString(),
          style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
          Divider(
          thickness: 0.8,
          ),
          ],
          ),
          );
          },
          itemCount: listResponse ==null? 0: listResponse.length,),
        ) : Padding(
          padding: const EdgeInsets.all(150.0),
          child: Center(child: CircularProgressIndicator(color: Colors.green)),
        )
      ],
    ));
  }
}
