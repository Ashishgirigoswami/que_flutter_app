import 'package:que/login.dart';
import 'package:que/home.dart';
import 'package:que/splash.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:que/provider/user_provider.dart';



//my own 

void main(){
  runApp(MultiProvider(providers:[
    ChangeNotifierProvider(create: (_)=>UserProvider.initialize(),),
     
  
  ],
  child:MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:Colors.red.shade900
      ),
      home:SplashScreen()
  )));
   
}


class ScreenController extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user=Provider.of<UserProvider>(context);
    switch(user.status){
      case Status.unintialized:
        return SplashScreen();
      case Status.unauthenticated:
      case Status.authenticating:
        return LoginPage();
      case Status.authenticated:
        return Homepage();
      default: return LoginPage();
    
    }
      
  }
}
