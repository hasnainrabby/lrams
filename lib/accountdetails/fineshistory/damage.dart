import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../auth_provider.dart';

late Map mapResponse;
late List listResponse;
bool isLoading = false;
final df = new DateFormat.yMMMMd();

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
        Uri.parse(
            'https://library.parliament.gov.bd:8080/api/profile/summary/fines/damage_lost/history'),
        headers: {'Authorization': 'Bearer $token'}); //Enter Real Url.
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
          title: Text(
            'Damage & Losts',
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
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
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Credit :' +
                                            listResponse[index]['credit']
                                                .toString(),
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
                                    children: [
                                      Text(
                                        'Fine Clear :' +
                                            listResponse[index]['is_fine_clear']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Description :' +
                                            listResponse[index]['description']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Created:' +
                                        df.format(DateTime.parse(
                                            (listResponse[index]
                                                ['created_at']))),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Updated:' +
                                        df.format(DateTime.parse(
                                            (listResponse[index]
                                                ['updated_at']))),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
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
