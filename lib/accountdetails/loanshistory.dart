import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

bool isLoading = false;
late Map mapResponse;
late List listResponse = [];
final df = new DateFormat.yMMMMd();

class loansHistory extends StatefulWidget {
  const loansHistory({Key? key}) : super(key: key);

  @override
  State<loansHistory> createState() => _loansHistoryState();
}

class _loansHistoryState extends State<loansHistory> {
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
        Uri.parse(
            'https://library.parliament.gov.bd:8080/api/profile/summary/loans/history'),
        headers: {'Authorization': 'Bearer $token'}); //Enter Real Url.
    if (response.statusCode == 200) {
      mapResponse = json.decode((response.body).toString());
      listResponse = mapResponse['data']['loans'];
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
          title: Text(
            'Loans History',
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.green,
              ))
            : listResponse == null || listResponse.isEmpty
                ? Center(
                    child: Text(
                      'No Data Found',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          child: Card(
                            elevation: 5,
                            color: Colors.green.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Loan Date :' +
                                            df.format(DateTime.parse(
                                                listResponse[index]
                                                    ['loan_date'])),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Credit :' +
                                            listResponse[index]['credit']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Due Date :' +
                                            df.format(DateTime.parse(
                                                listResponse[index]
                                                    ['due_date'])),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Debit :' +
                                            listResponse[index]['debit']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Return Date :' +
                                            df.format(DateTime.parse(
                                                listResponse[index]
                                                    ['return_date'])),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Return :' +
                                            listResponse[index]['is_return']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Status :' +
                                            listResponse[index]['status']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Fine Clear :' +
                                            listResponse[index]['fine_clear']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Renew :' +
                                            listResponse[index]['renew']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Discount Percentage :' +
                                            listResponse[index]
                                                    ['discount_percentage']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: listResponse == null ? 0 : listResponse.length,
                    ),
                  ));
  }
}
