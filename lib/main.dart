import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:bookshelf/home_page.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BookShelf());
}

class BookShelf extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF02340F),
        fontFamily: 'SegoeUI',
        textTheme:TextTheme(
          bodyText1:TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context)=>SplashScreen(),
        '/home': (context)=>HomePage(),
      },
    );
  }
}
