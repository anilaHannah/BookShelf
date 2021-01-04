import 'package:flutter/material.dart';
import 'package:bookshelf/components.dart';


class GenreBooks extends StatefulWidget {

  final String genre;
  GenreBooks({this.genre});

  @override
  _GenreBooksState createState() => _GenreBooksState();
}

class _GenreBooksState extends State<GenreBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 24.0),
              child: Text(
                widget.genre,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            BigBookCard(
              imageURL: 'https://images-na.ssl-images-amazon.com/images/I/81yheYBjiuL.jpg',
              bookName: 'Harry Potter and the order of phoenix',
              author: 'J.K Rowling',
            ),
            BigBookCard(
              imageURL: 'https://images-na.ssl-images-amazon.com/images/I/91HHqVTAJQL.jpg',
              bookName: 'Harry Potter and the chamber of secrets',
              author: 'J.K Rowling',
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}


