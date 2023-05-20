import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../auth_provider.dart';
import 'package:open_file/open_file.dart';

class LatestNews extends StatefulWidget {
  const LatestNews({super.key});

  @override
  _LatestNewsState createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
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
     // print('Downloading file from URL: $url');

      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission not granted');
      }

      final response = await get(Uri.parse(url));
     // print('Response status code: ${response.statusCode}');

      final documentDirectory = await getApplicationDocumentsDirectory();
      final file = File('${documentDirectory.path}/pdf_file.pdf');

      file.writeAsBytesSync(response.bodyBytes);
     // print('File downloaded and saved to: ${file.path}');
     // print(file.path);

      return file;
    } catch (e) {
     // print('Error downloading file: ${e.toString()}');
      throw Exception('Error opening pdf file');
    }
  }




  void _openPdf(BuildContext context, String url) async {
    try {
     // print('Opening PDF file from URL: $url');
      final file = await _downloadFile(url);
      await OpenFile.open(file.path);
     // print('PDF file opened successfully');
    } catch (e) {
     // print('Error opening PDF file: ${e.toString()}');
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
        backgroundColor: Colors.green,
        title: const Text('Letest News',
            style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureNews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              // No data found
              return const Center(
                child: Text('No News found',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat')),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final news = snapshot.data![index];
                return Card(
                  elevation: 5,
                  color: Colors.green.shade100,
                    shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),

                ),
                        side: BorderSide(width: 2, color: Colors.green)),
                  child: ListTile(
                    title: Text(news['title']),
                    subtitle: Text(news['news_date']),
                    trailing: IconButton(
                      icon: const Icon(
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
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        },
      ),
    );
  }
}