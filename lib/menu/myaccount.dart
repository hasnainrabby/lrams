import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lrams/accountdetails/fineshistory/finehistory.dart';
import 'package:lrams/accountdetails/loanshistory.dart';
import 'package:lrams/accountdetails/reservehistory.dart';
import 'package:lrams/accountdetails/searchhistory.dart';
import '../accountdetails/currentloanhistory.dart';
import '../accountdetails/profile.dart';
//Created by: Hasnain Rabby 01/02/2023

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
        title: const Text(
          'My Account',
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    side: BorderSide(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Profile",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
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
                  leading: const Icon(FontAwesomeIcons.addressBook),
                  title: const Text("Loans History",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const loansHistory()));
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
                  leading: const Icon(FontAwesomeIcons.addressBook),
                  title: const Text("Current Loan History",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const currentLoanHistory()));
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
                  leading: const Icon(FontAwesomeIcons.addressBook),
                  title: const Text("Fines History",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FineHistory()));
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
                  leading: const Icon(FontAwesomeIcons.addressBook),
                  title: const Text("Reserve History",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReserveHistory()));
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
                  leading: const Icon(FontAwesomeIcons.addressBook),
                  title: const Text("Search History",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchHistory()));
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
