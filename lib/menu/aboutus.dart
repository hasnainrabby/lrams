import 'package:flutter/material.dart';


class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/bangladesh-parliament-logo.png', width: 100, height: 100),
            const SizedBox(height: 20),
            const Text(
              'App Name:Library Research and Archive Management System',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center
            ),
            const SizedBox(height: 10),
            const Text(
              'App Version:1.0.0+1',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Design & Developed by: MS Electrohome',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
           // Image.asset('assets/images/2.JPG', width: 200, height: 100)
          ],
        ),
      ),
    );
  }
}
