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
import 'dart:developer' as logDev;

//Hasnain Rabby. Date:07/05/23

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedItem = 'title';
  List _books = [];
  final TextEditingController _searchController = TextEditingController();
  String token = '';
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    token = Provider.of<AuthProvider>(context).token;
    _getSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "LRAMS,Bangladesh National Parliament",
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(bottom: 30),
            child: searchView(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                      'Library Research and Archive Management System',
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          color: Colors.green)),
                ],
                isRepeatingAnimation: true,
                totalRepeatCount: 15,
              ),
            ),
          ),
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.60,
        child: Drawer(
          child: ListView(
            children: [
              const SizedBox(
                height: 90,
                child: DrawerHeader(
                    margin: EdgeInsets.only(left: 3.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(25)),
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/bangladesh-parliament-logo.png',
                          ),
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          scale: 4.0),
                    ),
                    child: Center(
                      child: Text('  LRAMS',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          )),
                    )),
              ),
              Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("My Account",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyAccount()));
                  },
                ),
              ),
              Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text("Notices",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const NoticePage()));
                  },
                ),
              ),
              Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: const Icon(Icons.newspaper),
                  title: const Text("E-clipping",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Eclipping()));
                  },
                ),
              ),
              Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: const Icon(FontAwesomeIcons.arrowLeft),
                  title: const Text("Log Out",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  onTap: () async {
                    // call the logout API to invalidate the token
                    final response = await post(
                        Uri.parse(
                            'https://library.parliament.gov.bd:8080/api/auth/logout'),
                        headers: {'Authorization': 'Bearer $token'});
                    if (response.statusCode == 200) {
                      // remove the token from the provider
                      Provider.of<AuthProvider>(context, listen: false).token;
                      // navigate to the login screen
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    } else {
                      debugPrint(
                          'Logout failed with error code ${response.statusCode}');
                      // show an error message if the logout API returns an error
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Logout failed. Please try again later.'),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                ),
              ),
              Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: const Icon(FontAwesomeIcons.noteSticky),
                  title: const Text("About Us",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AboutUsScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchView() {
    return Column(
      children: [
        Card(
          elevation: 5,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              side: BorderSide(width: 2, color: Colors.green)),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .55,
                  child: DropdownButton<String>(
                    value: _selectedItem,
                    onChanged: (value) =>
                        setState(() => _selectedItem = value!),
                    items: const [
                      DropdownMenuItem(
                          value: 'selected_category',
                          child: Text('Selected Category')),
                      DropdownMenuItem(value: 'title', child: Text('Title')),
                      DropdownMenuItem(value: 'author', child: Text('Author')),
                      DropdownMenuItem(
                          value: 'subject', child: Text('Subject')),
                      DropdownMenuItem(value: 'issn', child: Text('ISSN')),
                      DropdownMenuItem(value: 'isbn', child: Text('ISBN')),
                      DropdownMenuItem(
                          value: 'publisher', child: Text('Publisher')),
                      DropdownMenuItem(
                          value: 'call_number', child: Text('Call Number')),
                    ],
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                    dropdownColor: Colors.white,
                    underline: Container(
                      height: 2,
                      color: Colors.green,
                    ),
                    isExpanded: true,
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: ElevatedButton(
                    onPressed: _getSearchResults,
                    child: const Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 50.0),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
        Expanded(
            child: isLoading
                ? (_books.isEmpty)
                    ? const Center(child: Text("Please Search Books...."))
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      )
                : ListView.builder(
                    itemCount: _books.length,
                    itemBuilder: (context, index) =>
                        ListTiles(data: _books[index]),
                  )),
      ],
    );
  }

  Future<void> _getSearchResults() async {
    await _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> queryParameters = {};
      String selectedItem = _selectedItem.toLowerCase();
      String searchValue = _searchController.text;
      String searchKey = '';
      // Determine the search key based on the selected item in the dropdown menu
      switch (selectedItem) {
        case 'title':
          searchKey = 'title';
          break;
        case 'author':
          searchKey = 'author';
          break;
        case 'subject':
          searchKey = 'subject';
          break;

        // Add more cases for additional search options
        default:
          searchKey = 'title';
          break;
      }
      // Set the query parameters based on the selected item and entered text
      queryParameters['field'] = searchKey;
      queryParameters['search[0]'] = searchKey;
      queryParameters['searchValue[0]'] = searchValue;
      /* final queryParameters = {
        'search[0]': _selectedItem,
        'searchValue[0]': _searchController.text,
        'field': _selectedItem,
      };*/
      final uri = Uri.https(
        'library.parliament.gov.bd:8080',
        '/api/advance-search/book-search',
        queryParameters,
      );
      final response =
          await get(uri, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode != 200) {
        throw Exception('Request failed with status: ${response.statusCode}.');
      }
      logDev.log('Response body: ${response.body}');
      final responseData = json.decode(response.body);
      if (!responseData['status']) {
        throw Exception(
            'Request failed with error: ${responseData['message']}.');
      }
      final books = Book.fromJson(responseData);

      List bookList = books.data!.books!.data!.values.toList();
      _books = [];

      for (int i = 0; i < bookList.length; i++) {
        Map<String, dynamic> bookDetail = {};
        List<Datum> bookDetailList = bookList[i] as List<Datum>;
        for (int j = 0; j < bookDetailList.length; j++) {
          if (bookDetailList[j].subfieldId == 20) {
            bookDetail['title'] = bookDetailList[j].value;
          }
          if (bookDetailList[j].subfieldId == 23) {
            bookDetail['subtitle'] = bookDetailList[j].value;
          }
          if (bookDetailList[j].subfieldId == 231) {
            bookDetail['other_title'] = bookDetailList[j].value;
          }
          if (bookDetailList[j].subfieldId == 3) {
            bookDetail['author'] = bookDetailList[j].value;
          }
          if (bookDetailList[j].subfieldId == 11 ||
              bookDetailList[j].subfieldId == 16) {
            bookDetail['subject'] = bookDetailList[j].value;
          }
          if (bookDetailList[j].subfieldId == 14 ||
              bookDetailList[j].subfieldId == 16) {
            bookDetail['classification_number'] = bookDetailList[j].value;
          }
          if (bookDetailList[j].subfieldId == 17) {
            bookDetail['issn'] = bookDetailList[j].value;
          }
          if (bookDetailList[j].subfieldId == 29) {
            bookDetail['publisher1'] = bookDetailList[j].value;
          }
          if (bookDetailList[j].subfieldId == 30) {
            bookDetail['publisher2'] = bookDetailList[j].value;
          }
          if (bookDetailList[j].subfieldId == 32) {
            bookDetail['publisher3'] = bookDetailList[j].value;
          }
        }
        _books.add(bookDetail);
      }
      await Future.delayed(const Duration(seconds: 2), () {
        if (isLoading) {
          setState(() {
            isLoading = false;
            if (_books.isEmpty) {
              const Text("No books found.");
            }
          });
        }
      });
    } catch (e) {
      // Handle error
      print('Error fetching books: $e');
    }
  }
}

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

String bookToJson(Book data) => json.encode(data.toJson());

class Book {
  bool? status;
  String? message;
  Data? data;

  Book({
    this.status,
    this.message,
    this.data,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Books? books;
  dynamic suggestion;
  List<dynamic>? closest;
  dynamic keyword;
  List<ItemType>? itemType;

  Data({
    this.books,
    this.suggestion,
    this.closest,
    this.keyword,
    this.itemType,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        books: json["books"] == null ? null : Books.fromJson(json["books"]),
        suggestion: json["suggestion"],
        closest: json["closest"] == null
            ? []
            : List<dynamic>.from(json["closest"]!.map((x) => x)),
        keyword: json["keyword"],
        itemType: json["itemType"] == null
            ? []
            : List<ItemType>.from(
                json["itemType"]!.map((x) => ItemType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "books": books?.toJson(),
        "suggestion": suggestion,
        "closest":
            closest == null ? [] : List<dynamic>.from(closest!.map((x) => x)),
        "keyword": keyword,
        "itemType": itemType == null
            ? []
            : List<dynamic>.from(itemType!.map((x) => x.toJson())),
      };
}

class Books {
  int? currentPage;
  Map<String, List<Datum>>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Books({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Books.fromJson(Map<String, dynamic> json) => Books(
        currentPage: json["current_page"],
        data: Map.from(json["data"]!).map((k, v) =>
            MapEntry<String, List<Datum>>(
                k, List<Datum>.from(v.map((x) => Datum.fromJson(x))))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(
            k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  int? id;
  int? bibliographicId;
  int? bibliographicTagId;
  int? subfieldId;
  String? value;
  String? subfieldUiId;
  String? tagUiId;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? score;

  Datum({
    this.id,
    this.bibliographicId,
    this.bibliographicTagId,
    this.subfieldId,
    this.value,
    this.subfieldUiId,
    this.tagUiId,
    this.createdAt,
    this.updatedAt,
    this.score,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        bibliographicId: json["bibliographic_id"],
        bibliographicTagId: json["bibliographic_tag_id"],
        subfieldId: json["subfield_id"],
        value: json["value"],
        subfieldUiId: json["subfield_ui_id"],
        tagUiId: json["tag_ui_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        score: json["score"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bibliographic_id": bibliographicId,
        "bibliographic_tag_id": bibliographicTagId,
        "subfield_id": subfieldId,
        "value": value,
        "subfield_ui_id": subfieldUiId,
        "tag_ui_id": tagUiId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "score": score,
      };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class ItemType {
  String? value;

  ItemType({
    this.value,
  });

  factory ItemType.fromJson(Map<String, dynamic> json) => ItemType(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}

class ListTiles extends StatelessWidget {
  final Map<String, dynamic> data;

  const ListTiles({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.green.shade100,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          side: BorderSide(width: 2, color: Colors.white)),
      child: SingleChildScrollView(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  '${data['title'] ?? ''} ${data['subtitle'] ?? ''}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'By: ${data['author'] ?? ''}',
                style: const TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 1),
              Text(
                'Classification Number: ${data['classification_number'] ?? ''}',
                style: const TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 1),
              Text(
                data['other_title'] ?? '',
                style: const TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 1),
              Text(
                'Publisher:${data['publisher1'] ?? ''}${data['publisher2'] ?? ''}${data['publisher3']}',
                style: const TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
