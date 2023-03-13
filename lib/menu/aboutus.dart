import 'package:flutter/material.dart';


class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Image.asset('assets/images/logo.png', width: 100, height: 100),
          SizedBox(height: 20),
          Text(
            'Your Company Name',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Description of your company and what you do.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
