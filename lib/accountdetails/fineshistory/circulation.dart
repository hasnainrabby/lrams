import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../auth_provider.dart';
// Created by: Hasnain Rabby 16/02/2023

final df = DateFormat.yMMMMd();
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
        Uri.parse(
            'https://library.parliament.gov.bd:8080/api/profile/summary/fines/circulation/history'),
        headers: {
          'Authorization': 'Bearer $token'
        }); //Enter Real Url. its demo.
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
        title: const Text(
          'Circulation',
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.green),
            )
          : listResponse == null || listResponse.isEmpty
              ? const Center(
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
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Credit:${listResponse[index]['credit']}',
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Debit:${listResponse[index]['debit']}',
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Fine Clear:${listResponse[index]['fine_clear']}',
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Loan Date:${df.format(DateTime.parse(listResponse[index]['loan_date']))}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Due Date:${df.format(DateTime.parse(listResponse[index]['due_date']))}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Return Date:${df.format(DateTime.parse(listResponse[index]['return_date']))}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Return:${listResponse[index]['is_return']}',
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Status:${listResponse[index]['status']}',
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Renew:${listResponse[index]['renew']}',
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Discount Percentage:${listResponse[index]['discount_percentage']}',
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Discount Amount:${listResponse[index]['discount_amount']}',
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: listResponse == null ? 0 : listResponse.length,
                  ),
                ),
    );
  }
}
