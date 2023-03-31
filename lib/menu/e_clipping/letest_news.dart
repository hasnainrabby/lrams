import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../auth_provider.dart';
import 'package:open_file/open_file.dart';

class LetestNews extends StatefulWidget {
  @override
  _LetestNewsState createState() => _LetestNewsState();
}

class _LetestNewsState extends State<LetestNews> {
  late Future<List<dynamic>> _futureNews;
  String token = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = Provider.of<AuthProvider>(context).token;
    _futureNews = fetchNews();
  }

  Future<List<dynamic>> fetchNews() async {
    final token = Provider.of<AuthProvider>(context).token;
    final response = await get(
      Uri.parse('https://library.parliament.gov.bd:8080/api/e-clipping'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      Map<dynamic, dynamic> map = json.decode(response.body);

      return map['data']['eclippings'];
    } else {
      throw Exception(
          'Failed to load news.Response status code: ${response.statusCode}');
    }
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
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Letest News',
            style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureNews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final news = snapshot.data![index];
                return Card(
                  elevation: 5,
                  color: Colors.green.shade100,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),

                ),
                        side: BorderSide(width: 2, color: Colors.green)),
                  child: ListTile(
                    title: Text(news['title']),
                    subtitle: Text(news['news_date']),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.picture_as_pdf,
                        color: Colors.redAccent,
                      ),
                      onPressed: () async {
                        // Open PDF file
                        final url = news['file'];
                        _openPdf(context, url);
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        },
      ),
    );
  }
}