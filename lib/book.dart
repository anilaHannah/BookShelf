import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

final _firestore = FirebaseFirestore.instance;

class Book extends StatefulWidget {
  final String bookName, category;
  Book({this.bookName, this.category});

  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  String link = "";
  File file;
  var text;
  String contents = "";
  PDFDocument doc;

  @override
  void initState() {
    super.initState();
    getLink();
  }

  void getLink() async{
    DocumentSnapshot doc = await _firestore
        .collection('Books/${widget.category}/BookDetails')
        .doc('${widget.bookName}')
        .get();
    final details = doc.data();
    setState(() {
      link = details['link'];
      print(link);
    });
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: (link != "") ? Container(child: PDF.network(link)) : SizedBox(width: 1.0,),
    );
  }
}
