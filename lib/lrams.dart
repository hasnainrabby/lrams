import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'menu/search.dart';
import 'package:lrams/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//created by: Md Hasnain Rabby update on: 31/03/2023

class LRAMS extends StatefulWidget {
  const LRAMS({Key? key}) : super(key: key);

  @override
  State<LRAMS> createState() => _LRAMSState();
}

class _LRAMSState extends State<LRAMS> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Load rememberMe state
    loadRememberMe();
  }

  void loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        emailController.text = prefs.getString('email') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
    }
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                         Center(
                           child: Container(
                             margin: EdgeInsets.only(top: 50.0),
                             height: MediaQuery.of(context).size.height * 0.25,
                             width: MediaQuery.of(context).size.width * 1.0,
                            child: Center(
                              child: Column(
                                children: [
                                  Text("LRAMS", style:
                                  TextStyle(fontSize: 25,fontFamily: 'Montserrat',fontWeight: FontWeight.w500,color: Colors.white),),
                                  Text("Library Research and Archive Management System",style:
                                  TextStyle(fontSize: 15,fontFamily: 'Montserrat',color: Colors.white,),textAlign: TextAlign.center,),
                                  SizedBox(height: 10),
                                  Image.asset('assets/images/bangladesh-parliament-logo.png',
                                    height: MediaQuery.of(context).size.height * .15,),

                                ],

                              ),
                            ),
                        ),
                         ),
                      loginUI(),
                    ],
                  ),
                )
              ],
            ),
          ),
      );
  }

  Widget loginUI(){
    return Stack(
      children: [
        Column(
          children: [
            Container(
              child: Text("Login to your Account",style:
              TextStyle(fontSize:20,fontWeight:FontWeight.w700,fontFamily: 'Montserrat',color: Colors.white,),
                textAlign: TextAlign.center,),
            ),
            useremailtextFieldView(),
            passwordtextFieldView(),
            rememberMeCheckbox(),
            loginButton()
          ],
        )
      ],
    );
  }
  Widget rememberMeCheckbox(){
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Checkbox(
            side: MaterialStateBorderSide.resolveWith(
      (Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
    return const BorderSide(color: Colors.white);
    }
    return const BorderSide(color: Colors.white);
    },
    ),
            value: rememberMe,
            onChanged: (value){
              setState(() {
                rememberMe = value!;
              });
            },
          ),
          Text("Remember me",style: TextStyle(fontSize: 16,color: Colors.white,fontFamily: 'Montserrat',fontWeight:FontWeight.w700),)
        ],
      ),
    );
  }
//Username Field

  Widget useremailtextFieldView(){
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        style: TextStyle(
            color: Colors.white,),
        controller: emailController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8.0),
            fillColor: Colors.white,
            hintText: "Enter Your Email",
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.person,color: Colors.white70,),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.yellow.shade400),
            ),
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.white),
          )
        ),
      ),
    );
  }
  //Password Field

  Widget passwordtextFieldView(){
    return Container(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        style: TextStyle(
          color: Colors.white,),
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8.0),
            fillColor: Colors.white,
            hintText: "Enter your password",
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.lock,color: Colors.white70,),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.yellow.shade400),
            ),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.white),
            )
        ),
      ),
    );
  }
//Login Button
  Widget loginButton(){
    return Column(
      children: [
        GestureDetector(
          onTap: (){

            login(emailController.text.toString(),passwordController.text.toString(),context,rememberMe);

          },
          child: Container(
            // padding: EdgeInsets.all(20),
            height: MediaQuery.of(this.context).size.height/15,
            width: MediaQuery.of(this.context).size.width/4,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
                boxShadow:[BoxShadow(color: Colors.yellow.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3)) ]

            ),
            child: Center(child: Text("Login",style:
            TextStyle(color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 18),)),

          ),
        ),
      ],
    );
  }
}
//Login Function, call from API.
void login(String username, String password,BuildContext context,bool rememberMe) async {

  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  try{
    Response response = await post(Uri.parse('https://library.parliament.gov.bd:8080/api/auth/login'),
      headers: {
      'Content-Type': 'application/json'},
        body:json.encode({
          'email': username,
          'password' : password
        })
       );
    if(response.statusCode == 200){
      var data = json.decode(response.body.toString());
      final token = data['token'];
      authProvider.setToken(token);
      print(data['token']);
      print("Account login successfully");
      if (rememberMe) {
        await saveCredentials(username, password);
      }else{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('rememberMe', false);
        await prefs.setString('email', '');
        await prefs.setString('password', '');
      }

      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );

      final snackBar = SnackBar(
        duration: Duration(milliseconds: 900),
        content: Text("Successfully Login!",textAlign: TextAlign.center,style:
        TextStyle(fontSize:15,fontWeight:FontWeight.w700,fontFamily: 'Montserrat',color: Colors.yellow,),),
        backgroundColor: Colors.black54,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));

    }
    else{
      print('Login Failed');
      final snackBar = SnackBar(
        duration: Duration(milliseconds: 900),
        content: Text("Please Enter your email & password!",textAlign: TextAlign.center,style:
        TextStyle(fontSize:15,fontWeight:FontWeight.w700,fontFamily: 'Montserrat',color: Colors.white,),),
        backgroundColor: Colors.yellow.shade500,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  catch(e) {
    print(e.toString());
  }
}
Future<void> saveCredentials(String username, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('rememberMe', true);
  await prefs.setString('email', username);
  await prefs.setString('password', password);
}


