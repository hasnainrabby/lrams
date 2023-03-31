import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  //List to hold the notices
  late Map mapResponse;
  List notices = [];
  bool isLoading = false;
 // late String errorMessage;
  String token = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = Provider.of<AuthProvider>(context).token;
    fetchNotices();
  }
  void fetchNotices() async {
    setState(() {
      isLoading = true;
    });
    try {
      final token = Provider.of<AuthProvider>(context).token;
      final response =
      await get(Uri.parse('http://library.parliament.gov.bd:8080/api//notice'),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        setState(() {
          mapResponse = json.decode(response.body)['data'];
          notices = mapResponse['notices'];
        });
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Notices',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body:  Column(
        children: [
          !isLoading?
          Expanded(
            child: ListView.builder(
              itemCount: notices.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 5,
                  color: Colors.green.shade100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),

                      ),
                      side: BorderSide(width: 2, color: Colors.green)),
                  child: ListTile(
                    title: Text('Title :'+ notices[index]['title']),
                    subtitle: Text('Description:' + notices[index]['description']),
                  ),
                );
              },
            ),
          ) :
          Padding(
              padding: const EdgeInsets.all(150.0),
              child: Center(child: CircularProgressIndicator(color: Colors.green)),
            ),
        ],
      )

    );
  }
}
