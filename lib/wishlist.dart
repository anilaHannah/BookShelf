import 'package:flutter/material.dart';
import 'package:bookshelf/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
List<WishListBookCard> bookList = [];
var currentUserEmail;

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {

  @override
  void initState() {
    super.initState();
    bookList = [];
    currentUserEmail = FirebaseAuth.instance.currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 24.0, bottom: 20.0),
            child: Text(
              'WishListed Books',
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
      stream: _firestore.collection('users/$currentUserEmail/WishList').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final books = snapshot.data.docs;
          for (var book in books) {
            final bookName = book.data()['bookName'];
            final category = book.data()['category'];

            final bookCard = WishListBookCard(
              bookName: bookName,
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


class WishListBookCard extends StatefulWidget {

  final String bookName, path;
  WishListBookCard({this.bookName, this.path});

  @override
  _WishListBookCardState createState() => _WishListBookCardState();
}

class _WishListBookCardState extends State<WishListBookCard> {

  bool isVisible = true;
  String author = "", imageURL = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('Books').doc(widget.path).collection('BookDetails').doc(widget.bookName).snapshots(),
      builder: (context, snapshot){
        try{
          var variable = snapshot.data.data();
          setState(() {
            author = variable['author'];
            imageURL = variable['image'];
          });
        }
        catch(e){
          print(e);
        }
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 4.0),
            child: Card(
              color: Color(0xFFCEF6A0),
              child: Padding(
                padding: const EdgeInsets.only( left: 16.0, right: 16.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Image(
                        image: NetworkImage(imageURL),
                        width: 80.0,
                        height: 110.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 170.0,
                            child: Text(widget.bookName,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w900,
                              ),
                              maxLines: 4,
                            ),
                          ),
                          SizedBox(
                            width: 170.0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('by '+author,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(children: [
                              GestureDetector(
                                child: Material(
                                  color: Color(0xFF02340F),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                                    child: Text('Save', style: TextStyle(fontSize: 12.0, color: Colors.white),),
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
                                ),
                                onTap: () async {
                                  await _firestore.collection('users').doc(currentUserEmail).collection('SavedBooks').doc(widget.bookName).set({'bookName':widget.bookName, 'category': widget.path});
                                  await _firestore.collection('users').doc(currentUserEmail).collection('WishList').doc(widget.bookName).delete();
                                  setState(() {
                                    isVisible = false;
                                  });
                                  return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text("Successful", style: TextStyle(fontWeight: FontWeight.bold),),
                                      content: Text("${widget.bookName} has been saved to your collection!"),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                            Navigator.pushReplacement(
                                                context, MaterialPageRoute(builder: (BuildContext context) => WishList()));
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: GestureDetector(
                                    child: Material(
                                      color: Color(0xFF02340F),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                                        child: Text('Remove', style: TextStyle(fontSize: 12.0, color: Colors.white),),
                                      ),
                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
                                    ),
                                    onTap: () async {
                                      await _firestore.collection('users').doc(currentUserEmail).collection('WishList').doc(widget.bookName).delete();
                                      setState(() {
                                        isVisible = false;
                                      });
                                      return showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text("Successful", style: TextStyle(fontWeight: FontWeight.bold),),
                                          content: Text("${widget.bookName} has been removed from your WishList."),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(builder: (BuildContext context) => WishList()));
                                              },
                                              child: Text("OK"),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ],),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}