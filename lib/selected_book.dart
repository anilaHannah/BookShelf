import 'dart:io';
import 'package:bookshelf/currentbooks_fragment.dart';
import 'package:bookshelf/wishlist.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookshelf/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

final _firestore = FirebaseFirestore.instance;
var currentUserEmail;

class SelectedBook extends StatefulWidget {
  final String title, path;
  SelectedBook({this.title, this.path});

  @override
  _SelectedBookState createState() => _SelectedBookState();
}

class _SelectedBookState extends State<SelectedBook> {
  bool isSpiritual = false;
  String genre1 = "", genre2 = "", description = "", link = "", author = "", imageURL = "";
  List<Widget> similar = [];

  @override
  void initState() {
    super.initState();
    currentUserEmail = FirebaseAuth.instance.currentUser.email;
    print('Books/${widget.path}/BookDetails/${widget.title}');
    if (widget.path == 'Spiritual') isSpiritual = true;
    getDetails();
    getRowBooks();
  }

  void getPermission() async {
    await Permission.storage.request();
  }

  var dio = Dio();

  Future download(Dio dio, String url, String path) async {
    try {
      Response response = await dio.get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }));

      File file = File(path);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void getDetails() async {
    DocumentSnapshot doc = await _firestore
        .collection('Books/${widget.path}/BookDetails')
        .doc('${widget.title}')
        .get();
    final details = doc.data();
    setState(() {
      description = details['description'];
      link = details['link'];
      author = details['author'];
      imageURL = details['image'];
      if (!isSpiritual) {
        genre1 = details['genre1'];
        genre2 = details['genre2'];
      }
    });
  }

  void getRowBooks() {
    int i = 0;
    print('Books/${widget.path}/BookDetails');
    Stream<QuerySnapshot> doc =
        _firestore.collection('Books/${widget.path}/BookDetails').snapshots();
    doc.forEach((element) {
      var books = element.docs.asMap();
      for (var key in books.keys) {
        if (i < 6) {
          final image = element.docs[key]['image'];
          final bookName = element.docs[key]['bookName'];
          final author = element.docs[key]['author'];
          print(bookName);
          var book = BookCard(
            author: author,
            bookName: bookName,
            imageURL: image,
            path: widget.path,
          );
          setState(() {
            if (bookName != widget.title) similar.add(book);
          });
          i++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCEF6A0),
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 16.0, right: 16.0, bottom: 10.0),
              child: Row(
                children: [
                  (imageURL == null) ?
                      Icon(Icons.book) :
                  Image(
                    image: NetworkImage(imageURL),
                    width: 120.0,
                    height: 190.0,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 170.0,
                          child: Text(
                            widget.title,
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
                            child: Text(
                              'by ' + author,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: RatingBar.builder(
                            initialRating: 5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20.0,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.black,
                            ),
                            onRatingUpdate: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            isSpiritual ? 'Spiritual' : '$genre1 | $genre2',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MaterialButton(
                                onPressed: () async {
                                  await _firestore
                                      .collection('users')
                                      .doc(currentUserEmail)
                                      .collection('SavedBooks')
                                      .doc(widget.title)
                                      .set({
                                    'bookName': widget.title,
                                    'category': widget.path,
                                  });
                                  return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text("Successful", style: TextStyle(fontWeight: FontWeight.bold),),
                                      content: Text("${widget.title} has been saved to your collection!"),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                color: Color(0xFF02340F),
                                textColor: Colors.white,
                                child: SvgPicture.asset(
                                  'assets/save.svg',
                                  width: 16.0,
                                  height: 16.0,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(16),
                                shape: CircleBorder(),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  await _firestore
                                      .collection('users')
                                      .doc(currentUserEmail)
                                      .collection('WishList')
                                      .doc(widget.title)
                                      .set({
                                    'bookName': widget.title,
                                    'category': widget.path,
                                  });
                                  return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text("Successful", style: TextStyle(fontWeight: FontWeight.bold),),
                                      content: Text("${widget.title} has been added to your WishList!"),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                },

                                color: Color(0xFF02340F),
                                textColor: Colors.white,
                                child: SvgPicture.asset(
                                  'assets/wishlist.svg',
                                  width: 16.0,
                                  height: 16.0,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(16),
                                shape: CircleBorder(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x20000000),
                    offset: Offset(0.0, -1.0),
                    blurRadius: 20.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7.0, left: 28.0),
                    child: Text(
                      'About the Book',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 28.0, top: 10.0, right: 28.0),
                    child: SizedBox(
                      width: 200.0,
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                        maxLines: 13,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  BookRows(
                    rowHeading: 'Similar Books',
                    rowContent: similar,
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
