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
                        Text('ISBN: ${_books[index].isbn}',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
                        SizedBox(width: 20.0,),
                        Text('Available: ${_books[index].visibility.toString()}',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500, color: Colors.green),),
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
    //  print('Response body: ${response.body}');
      final responseData = json.decode(response.body);
      if (!responseData['status']) {
        throw Exception('Request failed with error: ${responseData['message']}.');
      }
      var data = responseData['data'];
      print('Response data: $data');
      if (data == null || data['books'] == null) {
        throw Exception('Request failed with error: Data format is invalid.');
      }
      final booksData = data['books'] as List<dynamic>;
      final books = booksData.map((bookData) => Book.fromJson(bookData)).toList();

      setState(() {
        _books = books;
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
  final int id;
  final String title;
  final String author;
  final String issn;
  final String isbn;
  final int visibility;
 // final int price;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.issn,
    required this.isbn,
    required this.visibility,
   // required this.price,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final bookData = json;
    return Book(
      id: bookData['id'],
      title: bookData['title'] ,
      author: bookData['author'] ,
      issn: bookData['issn'],
      isbn: bookData['isbn'],
      visibility: bookData['visibility'],
     // price: bookData['price'],
    );
  }
}


