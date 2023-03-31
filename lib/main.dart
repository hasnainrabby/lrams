import 'package:flutter/material.dart';
import 'package:lrams/auth_provider.dart';
import 'package:provider/provider.dart';
import 'lrams.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_)=> AuthProvider(),
      child: MaterialApp(theme: ThemeData(primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,),
          home: LRAMS(),
      onGenerateRoute: (RouteSettings settings){
        switch (settings.name) {
          case "/login":
            return MaterialPageRoute(builder: (context) => LRAMS());
          default:
            return null;
        }
      },));
  }

}



