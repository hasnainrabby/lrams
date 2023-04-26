import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:lrams/menu/aboutus.dart';
import 'package:lrams/menu/myaccount.dart';
import 'package:lrams/menu/notices.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import 'e_clipping/eclipping.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  String _selectedItem = 'title';
  List _books = [];
  TextEditingController _searchController = TextEditingController();
  String token = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    token = Provider.of<AuthProvider>(context).token;
  //  _fetchBooks();
    _getSearchResults();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("LRAMS,Bangladesh National Parliament",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500,fontSize: 16),),
        centerTitle: true,
      ),
      body:Stack(
        children: [
          Center(
            child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 8.0),
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width * 1.0,
                child:AnimatedTextKit(animatedTexts: [
                  TyperAnimatedText('Welcome To Library Research and Archive Management System',textStyle: TextStyle(
                      fontWeight: FontWeight.w500,fontSize: 12,fontFamily: 'Montserrat',color: Colors.green
                  ) ),
                ],
                  isRepeatingAnimation: true,
                  totalRepeatCount: 15,)
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: searchView(),
          )
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.60,
        child: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 90,
                child: DrawerHeader(
                    margin: EdgeInsets.only(left: 3.0),
                    decoration:
                    BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(bottomRight:Radius.circular(25)),
                      image: DecorationImage(image: AssetImage('assets/images/bangladesh-parliament-logo.png',
                      ),
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          scale: 4.0),
                    ),
                    child: Center(
                      child: Text('  LRAMS',
                          textAlign: TextAlign.right,
                          style:
                          TextStyle(fontSize:25,fontWeight:FontWeight.w700,fontFamily: 'Montserrat',color: Colors.white,
                          )),
                    )),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),

                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("My Account", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyAccount()));
                  },
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),

                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text("Notices", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoticePage()));
                  },
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: Icon(Icons.newspaper),
                  title: Text("E-clipping", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Eclipping()));
                  },
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.noteSticky),
                  title: Text("Log Out", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: () async {
                    // call the logout API to invalidate the token
                    final response = await post(Uri.parse('https://library.parliament.gov.bd:8080/api/auth/logout'),
                        headers: {'Authorization': 'Bearer $token'});
                    if (response.statusCode == 200) {
                      // remove the token from the provider
                      Provider.of<AuthProvider>(context, listen: false).token;
                      // navigate to the login screen
                      Navigator.pushNamedAndRemoveUntil(context,'/login', (route) => false);
                    } else {
                      debugPrint('Logout failed with error code ${response.statusCode}');
                      // show an error message if the logout API returns an error
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Logout failed. Please try again later.'),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.noteSticky),
                  title: Text("About Us", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget searchView(){
    return  Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: _selectedItem,
              onChanged: (value) => setState(() => _selectedItem = value!),
              items: [
                DropdownMenuItem(value: 'title', child: Text('Title')),
                DropdownMenuItem(value: 'author', child: Text('Author')),
                DropdownMenuItem(value: 'subject', child: Text('Subject')),
                DropdownMenuItem(value: 'issn', child: Text('ISSN')),
                DropdownMenuItem(value: 'isbn', child: Text('ISBN')),
                DropdownMenuItem(value: 'accession_number', child: Text('Accession Number')),
                DropdownMenuItem(value: 'call_number', child: Text('Call Number')),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _fetchBooks,
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            Expanded(
                child: ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(_books[index].title,style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
                    subtitle:Row(
                      children: [
                        Text(_books[index].author,style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
                        SizedBox(width: 20.0,),
                        Text('ISBN: ${_books[index].otherTitle}',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
                        SizedBox(width: 20.0,),
                        Text(_books[index].publisher,style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500, color: Colors.green),),
                    ],)
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  Future<void> _getSearchResults() async {
    await _fetchBooks();
  }
  Future<void> _fetchBooks() async {
    try {
      final queryParameters = {
        'search[0]': _selectedItem,
        'searchValue[0]': _searchController.text,
      };
      final uri = Uri.https(
        'library.parliament.gov.bd:8080',
        '/api/advance-search/book-search',
        queryParameters,
      );
      final response = await get(uri, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode != 200) {
        throw Exception('Request failed with status: ${response.statusCode}.');
      }
      print('Response body: ${response.body}');
      final responseData = json.decode(response.body);
      if (!responseData['status']) {
        throw Exception('Request failed with error: ${responseData['message']}.');
      }
      var data = responseData['data']['books']['data'];
     // print('Response data: $data');
      /*if (data == null || data['data'] == null) {
        throw Exception('Request failed with error: Data format is invalid.');
      }*/
      final booksData = data['data'] as List<dynamic>;
      final books = booksData.map((bookData) => Book.fromJson(bookData)).toList();

      setState(() {
        _books = books;
        print(_books);
        if (data['suggestion'] != null) {
          // Display suggestion to user
          print('Suggestion: ${data['suggestion']}');
        }
      });
    }  catch (e) {
      // Handle error
      print('Error fetching books: $e');
    }
  }
}

class Book {
  final String title;
  final String author;
  final String classificationNumber;
  final String otherTitle;
  final String publisher;
  final String description;

  Book({
    required this.title,
    required this.author,
    required this.classificationNumber,
    required this.otherTitle,
    required this.publisher,
    required this.description,
  });
  factory Book.fromJson(Map<String, dynamic> json) {
    String title = '';
    String author = '';
    String classificationNumber = '';
    String otherTitle = '';
    String publisher = '';
    String description = '';

    // Loop through all fields in the record
    json.forEach((key, value) {
      if (value is List) {
        // Loop through all subfields in each field
        value.forEach((subfield) {
          if (subfield['subfield'] == '20') {
            // Found a subfield containing title data
            title += subfield['value'] ?? '';
          } else if (subfield['subfield'] == '3') {
            // Found a subfield containing author data
            author += subfield['value'] ?? '';
          } else if (subfield['subfield'] == '14') {
            // Found a subfield containing classification number data
            classificationNumber += subfield['value'] ?? '';
          } else if (subfield['subfield'] == '23') {
            // Found a subfield containing other title data
            otherTitle += subfield['value'] ?? '';
          } else if (subfield['subfield'] == '29') {
            // Found a subfield containing publisher data
            publisher += subfield['value'] ?? '';
          } else if (subfield['subfield'] == '30' || subfield['subfield'] == '32' || subfield['subfield'] == '34') {
            // Found a subfield containing description data
            description += subfield['value'] ?? '';
          }
        });
      }
    });

    return Book(
      title: title,
      author: author,
      classificationNumber: classificationNumber,
      otherTitle: otherTitle,
      publisher: publisher,
      description: description,
    );
  }

  /*factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: '${json[59][8]['value'] ?? ''} ${json[59][9]['value'] ?? ''}',
      author: json[7]['value'] ?? '',
      classificationNumber:
      '${json[6]['value'] ?? ''} ${json[16]['value'] ?? ''}',
      otherTitle: json[10]['value'] ?? '',
      publisher:
      '${json[11]['value'] ?? ''} ${json[12]['value'] ?? ''} ${json[13]['value'] ?? ''}',
      description:
      '${json[14]['value'] ?? ''} ${json[15]['value'] ?? ''} ${json[16]['value'] ?? ''}',
    );
  }*/
}



