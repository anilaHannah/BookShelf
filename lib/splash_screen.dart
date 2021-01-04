import 'package:flutter/material.dart';
import 'package:bookshelf/login_page.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookshelf/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    bool isUser;
    if(FirebaseAuth.instance.currentUser != null)
      isUser = true;
    else
      isUser = false;
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => isUser ? HomePage() : LoginPage())));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/logo.jpg'),
              width: 300.0,
              height: 350.0,
            ),
            Text(
              'BookShelf',
              style: TextStyle(
                fontSize: 100.0,
                fontFamily: 'Dandelion',
                color: Color(0xFF02340F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
