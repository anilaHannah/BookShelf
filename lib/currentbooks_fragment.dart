import 'package:flutter/material.dart';
import 'package:bookshelf/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final _firestore = FirebaseFirestore.instance;
List<IncompleteBookCard> bookList = [];
var currentUserEmail;

class CurrentBooksFragment extends StatefulWidget {
  @override
  _CurrentBooksFragmentState createState() => _CurrentBooksFragmentState();
}

class _CurrentBooksFragmentState extends State<CurrentBooksFragment> {

  @override
  void initState() {
    super.initState();
    currentUserEmail = FirebaseAuth.instance.currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 24.0, bottom: 20.0),
            child: Text(
              'Continue Reading',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          BookStream(),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}


class BookStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users/$currentUserEmail/SavedBooks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final books = snapshot.data.docs;
          for (var book in books) {
            final imageURL = book.data()['image'];
            final bookName = book.data()['bookName'];
            final author = book.data()['author'];
            final category = book.data()['category'];

            final bookCard = IncompleteBookCard(
              imageURL: imageURL,
              bookName: bookName,
              author: author,
              path: category,
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