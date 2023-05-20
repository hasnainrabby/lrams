import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../auth_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SearchNews extends StatefulWidget {
  const SearchNews({Key? key}) : super(key: key);

  @override
  State<SearchNews> createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<dynamic> _searchResults = [];
  String token = '';
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = Provider.of<AuthProvider>(context, listen: false).token;
    _searchNews();
  }

  void _searchNews() async {
    setState(() {
      _isLoading = true;
    });

    final token = Provider.of<AuthProvider>(context, listen: false).token;

    // Construct the URL for the API call
    String apiUrl =
        "https://library.parliament.gov.bd:8080/api/e-clipping/search_news?";
    apiUrl += "title=${_titleController.text}";
    apiUrl += "&keywords=${_keywordsController.text}";
    apiUrl += "&start_date=${_startDate?.toString().substring(0, 10)}";
    apiUrl += "&end_date=${_endDate?.toString().substring(0, 10)}";

    // Call the API and parse the JSON response
    var response = await get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    var data = json.decode(response.body);
    setState(() {
      _searchResults = data["data"]["allNews"];
      _isLoading = false;
      if (_searchResults.isEmpty) {
        Text("No News Found");
      }
    });
  }

  Future<File> _downloadFile(String url) async {
    try {
      final response = await get(Uri.parse(url));
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission not granted');
      }

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
      //print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Could not open PDF file'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search News",
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _keywordsController,
                decoration: const InputDecoration(
                  labelText: "Keywords",
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _startDate == null
                            ? "Start Date"
                            : "Start Date: ${_startDate?.toString().substring(0, 10)}",
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(
                        Icons.calendar_today,
                        color: Colors.green,
                      ),
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _endDate == null
                            ? "End Date"
                            : "End Date: ${_endDate?.toString().substring(0, 10)}",
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500),
                      ),
                      trailing:
                          const Icon(Icons.calendar_today, color: Colors.green),
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
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Search News'),
                onPressed: _searchNews,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Search News Results:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                ],
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const Center(
                      child: LinearProgressIndicator(),
                    )
                  : _searchResults == null || _searchResults.isEmpty
                      ? const Center(
                          child: Text('No News found',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat')))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: _searchResults.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 5,
                              color: Colors.green.shade100,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                  ),
                                  side: BorderSide(
                                      width: 2, color: Colors.green)),
                              child: ListTile(
                                title: Text(_searchResults[index]["title"]),
                                subtitle:
                                    Text(_searchResults[index]["news_date"]),
                                trailing: IconButton(
                                  icon: const Icon(
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
