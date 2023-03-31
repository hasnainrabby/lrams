import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lrams/menu/e_clipping/letest_news.dart';
import 'package:lrams/menu/e_clipping/search_news.dart';

class Eclipping extends StatefulWidget {
  const Eclipping({Key? key}) : super(key: key);

  @override
  State<Eclipping> createState() => _EclippingState();
}

class _EclippingState extends State<Eclipping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('E-clipping',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
          centerTitle: true
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),

                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.bookmark),
                  title: Text("Letest News", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LetestNews()));
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
                  leading: Icon(FontAwesomeIcons.bookmark),
                  title: Text("Search News", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchNews()));
                  },

                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


