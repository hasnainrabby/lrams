import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';


late Map mapResponse;
late List listResponse;
bool isLoading = false;
class SearchHistory extends StatefulWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
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
        Uri.parse('https://library.parliament.gov.bd:8080/api/profile/summary/search/history'),
         headers:{'Authorization': 'Bearer $token'}); //Enter Real Url.
    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      listResponse = mapResponse['data']['search_historys'];  //add reserve from api
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
          title: Text('Search History',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
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
                    /*  Text('User ID :'+listResponse[index]['user_id'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),*/
                      Text('Category :'+listResponse[index]['category'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),
                      Text('Title :'+listResponse[index]['keyword_value'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w500),),
                      Divider(
                        thickness: 0.8,
                      ),
                    ],
                  ),
                );
              },
                itemCount: listResponse ==null? 0: listResponse.length,),
            ):Padding(
              padding: const EdgeInsets.all(150.0),
              child: Center(child: CircularProgressIndicator(color: Colors.green)),
            )
          ],
        )
    );
  }
}
