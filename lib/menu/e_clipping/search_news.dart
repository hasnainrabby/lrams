import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../auth_provider.dart';
import 'package:intl/intl.dart';
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
  List _searchResults = [];
  String token = '';
  bool _isLoading = false;
  FocusNode _titleFocusNode = FocusNode();
  FocusNode _keywordsFocusNode = FocusNode();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = Provider.of<AuthProvider>(context, listen: false).token;
    _searchNews();
  }
  @override
  void dispose() {
    _titleController.dispose();
    _keywordsController.dispose();
    _titleFocusNode.dispose();
    _keywordsFocusNode.dispose();
    super.dispose();
  }

  void _searchNews() async {
    setState(() {
      _isLoading = true;
    });
    // Reset the search results
    setState(() {
      _searchResults = [];
    });

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    // Unfocus the text fields
    _titleFocusNode.unfocus();
    _keywordsFocusNode.unfocus();

    // Construct the URL for the API call
    String apiUrl =
        "https://library.parliament.gov.bd:8080/api/e-clipping/search_news?";

    if (_titleController.text.isNotEmpty) {
      apiUrl += "title=${_titleController.text}&";
    }
    if (_keywordsController.text.isNotEmpty) {
      apiUrl += "&keywords=${_keywordsController.text}&";
    }
    if (_startDate != null) {
      final formattedStartDate = DateFormat('yyyy-MM-dd').format(_startDate!);
      print('Formatted Start Date: $formattedStartDate');
      apiUrl += "start_date=$formattedStartDate&";
    }

    if (_endDate != null) {
      final formattedEndDate = DateFormat('yyyy-MM-dd').format(_endDate!);
      print('Formatted End Date: $formattedEndDate');
      apiUrl += "end_date=$formattedEndDate";
    }
    // Remove the trailing '&' character from the URL
    if (apiUrl.endsWith("&")) {
      apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    }

    var response = await get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    if(response.statusCode == 200){
      var dataResponse = json.decode(response.body);
      var news = News.fromJson(dataResponse);
      setState(() {
        _searchResults = news.data!.allNews!.data!;
        _isLoading = false;
        if (_searchResults.isEmpty) {
          // Show a message indicating no news found
          Text("No News Found");
        }
      });
    }else{// Handle error case
      setState(() {
        _isLoading = false;
        // Show an error message to the user
      });}

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
                focusNode: _titleFocusNode,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _keywordsController,
                focusNode: _keywordsFocusNode,
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
                                title: Text(_searchResults[index].title),
                                subtitle:
                                    Text(_searchResults[index].newsDate),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () async {
                                    // Open PDF file
                                    final url = _searchResults[index].file;
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
class News {
  bool? status;
  String? message;
  NewsData? data;

  News({this.status, this.message, this.data});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ?  NewsData.fromJson(json['data']): null,
    );
  }
}

class NewsData {
  AllNews? allNews;

  NewsData({this.allNews});

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      allNews: json['allNews'] !=null? AllNews.fromJson(json['allNews']): null,
    );
  }
}

class AllNews {
  int? currentPage;
  List<NewsItem>? data;

  AllNews({this.currentPage, this.data});

  factory AllNews.fromJson(Map<String, dynamic> json) {
    return AllNews(
      currentPage: json['current_page'],
      data: (json['data'] as List<dynamic>?)
          ?.map((x) => NewsItem.fromJson(x))
          .toList(),
      // List<NewsItem>.from(json['data'].map((x) => NewsItem.fromJson(x))),
    );
  }
}

class NewsItem {
  int? id;
  int? order;
  String? title;
  dynamic concernIssue;
  String? newsDate;
  int? sourceId;
  String? file;
  dynamic member;
  dynamic keyword;
  dynamic description;
  String? createdAt;
  String? updatedAt;
  String? isShowable;
  int? status;
  String? newsLink;
  String? newsLanguage;
  int? mailSent;
  NewsSource? source;

  NewsItem({
    this.id,
    this.order,
    this.title,
    this.concernIssue,
    this.newsDate,
    this.sourceId,
    this.file,
    this.member,
    this.keyword,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.isShowable,
    this.status,
    this.newsLink,
    this.newsLanguage,
    this.mailSent,
    this.source,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      order: json['order'],
      title: json['title'],
      concernIssue: json['concern_issue'],
      newsDate: json['news_date'],
      sourceId: json['source_id'],
      file: json['file'],
      member: json['member'],
      keyword: json['keyword'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isShowable: json['is_showable'],
      status: json['status'],
      newsLink: json['news_link'],
      newsLanguage: json['news_language'],
      mailSent: json['mail_sent'],
      source: json['source'] != null? NewsSource.fromJson(json['source']): null,
    );
  }
}

class NewsSource {
  int? id;
  String? name;
  String? url;
  String? logo;
  String? createdAt;
  String? updatedAt;

  NewsSource({
    this.id,
    this.name,
    this.url,
    this.logo,
    this.createdAt,
    this.updatedAt,
  });

  factory NewsSource.fromJson(Map<String, dynamic> json) {
    return NewsSource(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      logo: json['logo'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

