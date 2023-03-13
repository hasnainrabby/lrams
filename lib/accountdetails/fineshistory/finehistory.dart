import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'circulation.dart';
import 'damage.dart';

class FineHistory extends StatefulWidget {
  const FineHistory({Key? key}) : super(key: key);

  @override
  State<FineHistory> createState() => _FineHistoryState();
}

class _FineHistoryState extends State<FineHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Fines History',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
    centerTitle: true,),
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
                  title: Text("Circulation", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Circulation()));
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
                  title: Text("Damage & Losts", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Damage()));
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
