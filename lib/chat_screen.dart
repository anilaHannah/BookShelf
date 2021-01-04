import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final IconData image;

  ChatScreen({this.name, this.image});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  InputDecoration messageFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
    labelStyle: TextStyle(color: Colors.black),
    hintText: 'Type Message',
    suffixIcon: Icon(
      Icons.send,
      color: Color(0xFF02340F),
      size: 20.0,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    fillColor: Colors.white,
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 15.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundColor: Color(0xFF02340F),
              child: Icon(
                widget.image,
                color: Color(0xFFCEF6A0),
                size: 30.0,
              ),
            ),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFFCEF6A0),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF02340F), width: 2.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        controller: messageTextController,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: null,
                        decoration: messageFieldDecoration,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Material(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: CircleAvatar(
                          backgroundColor: Color(0xFF02340F),
                          child: SvgPicture.asset(
                            'assets/share.svg',
                            color: Colors.white,
                            width: 20.0,
                            height: 20.0,
                          ),
                          radius: 25.0,
                        ),
                      ),
                    ),
                    onTap: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
