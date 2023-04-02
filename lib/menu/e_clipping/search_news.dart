import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../auth_provider.dart';

class SearchNews extends StatefulWidget {
  const SearchNews({Key? key}) : super(key: key);

  @override
  State<SearchNews> createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _keywordsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<dynamic> _searchResults = [];
  String token = '';
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = Provider.of<AuthProvider>(context,listen: false).token;
    print('Token: $token');
    _searchNews();
  }

  void _searchNews() async {
    setState(() {
      _isLoading = true;
    });

    final token = Provider.of<AuthProvider>(context, listen: false).token;

    // Construct the URL for the API call
    String apiUrl = "https://library.parliament.gov.bd:8080/api/e-clipping/search_news?";
    apiUrl += "title=${_titleController.text}";
    apiUrl += "&keywords=${_keywordsController.text}";
    apiUrl += "&start_date=${_startDate?.toString().substring(0, 10)}";
    apiUrl += "&end_date=${_endDate?.toString().substring(0, 10)}";

    // Call the API and parse the JSON response
    var response = await get(Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},);

    var data = json.decode(response.body);
    setState(() {
      _searchResults = data["data"]["allNews"];
      _isLoading = false;
    });
  }
  Future<File> _downloadFile(String url) async {
    try {
      final response = await get(Uri.parse(url));

      final documentDirectory = await getApplicationDocumentsDirectory();

      final file = File('${documentDirectory.path}/pdf_file.pdf');

      file.writeAsBytesSync(response.bodyBytes);

      return file;
    } catch (e) {
      throw Exception('Error opening pdf file');
    }
  }

  void _openPdf(BuildContext context, String url) async {
    try {
      final file = await _downloadFile(url);
      await OpenFile.open(file.path);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not open PDF file'),
        duration: Duration(seconds: 3),
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search News",
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500)),
        centerTitle: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Title",
            ),
          ),
            SizedBox(height: 10),
            TextField(
              controller: _keywordsController,
              decoration: InputDecoration(
                labelText: "Keywords",
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(_startDate == null ? "Start Date" : "Start Date: ${_startDate?.toString().substring(0, 10)}",
                      style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500),),
                    trailing: Icon(Icons.calendar_today,color: Colors.green,),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          _startDate = picked;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ListTile(
                    title: Text(_endDate == null ? "End Date" : "End Date: ${_endDate?.toString().substring(0, 10)}",
                      style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500),),
                    trailing: Icon(Icons.calendar_today,color: Colors.green),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          _endDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Search News'),
              onPressed:    _searchNews,
            ),
            SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  :
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Search News Results:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,fontFamily: 'Montserrat')),
              ],
            ),
            SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 5,
                    color: Colors.green.shade100,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                        ),
                        side: BorderSide(width: 2, color: Colors.green)),
                    child:  ListTile(
                      title: Text(_searchResults[index]["title"]),
                      subtitle: Text(_searchResults[index]["news_date"]),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.redAccent,
                        ),
                        onPressed: () async {
                          // Open PDF file
                          final url = _searchResults[index]['file'];
                          _openPdf(context, url);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

