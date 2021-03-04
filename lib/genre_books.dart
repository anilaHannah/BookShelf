import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookshelf/components.dart';

final _firestore = FirebaseFirestore.instance;

List<BigBookCard> bookList = [];
List<BigBookCard> bookList2 = [];

class GenreBooks extends StatefulWidget {
  final String genre, path;
  GenreBooks({this.genre, this.path});

  @override
  _GenreBooksState createState() => _GenreBooksState();
}

class _GenreBooksState extends State<GenreBooks> {

  @override
  Widget build(BuildContext context) {
    bookList = [];
    bookList2 = [];
    return Scaffold(
      appBar: appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 24.0, bottom: 20.0),
            child: Text(
              widget.genre,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          (widget.path == 'Spiritual')
              ? BookStream(
                  path: widget.path,
                  genre: widget.genre,
                )
              : BookStream1(
            path: widget.path,
            genre: widget.genre,
          ),
          (widget.path != 'Spiritual')
              ?  BookStream2(
            path: widget.path,
            genre: widget.genre,
          ) : SizedBox(height: 1.0,),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}

class BookStream extends StatelessWidget {
  final String path, genre;
  BookStream({this.path, this.genre});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Books/$path/BookDetails').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final books = snapshot.data.docs;
          for (var book in books) {
            final bookName = book.data()['bookName'];

            final bookCard = BigBookCard(
              bookName: bookName,
              path: path,
            );
            bookList.add(bookCard);
          }
          return Expanded(
            child: ListView(
              children: bookList,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFF02340F),
            ),
          );
        }
      },
    );
  }
}

class BookStream1 extends StatelessWidget {
  final String path, genre;
  BookStream1({this.path, this.genre});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
              .collection('Books/$path/BookDetails')
              .where('genre1', isEqualTo: genre)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final books = snapshot.data.docs;
          for (var book in books) {
            final bookName = book.data()['bookName'];

            final bookCard = BigBookCard(
              bookName: bookName,
              path: path,
            );
            bookList2.add(bookCard);
          }
          return SizedBox(height: 1.0,);
        } else {
          return Center(
            child: SizedBox(height: 1.0,),
          );
        }
      },
    );
  }
}

class BookStream2 extends StatelessWidget {
  final String path, genre;
  BookStream2({this.path, this.genre});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Books/$path/BookDetails')
          .where('genre2', isEqualTo: genre)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final books = snapshot.data.docs;
          for (var book in books) {
            final bookName = book.data()['bookName'];

            final bookCard = BigBookCard(
              bookName: bookName,
              path: path,
            );
            bookList2.add(bookCard);
          }
          return Expanded(
            child: ListView(
              children: bookList2,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFF02340F),
            ),
          );
        }
      },
    );
  }
}
