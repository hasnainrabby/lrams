import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lrams/accountdetails/fineshistory/finehistory.dart';
import 'package:lrams/accountdetails/loanshistory.dart';
import 'package:lrams/accountdetails/reservehistory.dart';
import 'package:lrams/accountdetails/searchhistory.dart';
import '../accountdetails/currentloanhistory.dart';
import '../accountdetails/profile.dart';


class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('My Account',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500),),
      centerTitle: true,),
      body:ListView(
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
                  leading: Icon(Icons.person),
                  title: Text("Profile", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
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
                  leading: Icon(FontAwesomeIcons.addressBook),
                  title: Text("Loans History", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => loansHistory()));
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
                  leading: Icon(FontAwesomeIcons.addressBook),
                  title: Text("Current Loan History", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => currentLoanHistory()));
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
                  leading: Icon(FontAwesomeIcons.addressBook),
                  title: Text("Fines History", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FineHistory()));
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
                  leading: Icon(FontAwesomeIcons.addressBook),
                  title: Text("Reserve History", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReserveHistory()));
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
                  leading: Icon(FontAwesomeIcons.addressBook),
                  title: Text("Search History", style:
                  TextStyle(fontSize:18,fontWeight:FontWeight.w500,fontFamily: 'Montserrat')),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchHistory()));
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
