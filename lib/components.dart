import 'package:bookshelf/book_page.dart';
import 'package:flutter/material.dart';
import 'package:bookshelf/selected_book.dart';
import 'package:bookshelf/genre_books.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookshelf/book.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

final _firestore = FirebaseFirestore.instance;

class DividerWidget extends StatelessWidget {
  final double left, right;
  DividerWidget({this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: new Container(
        margin: EdgeInsets.only(left: left, right: right),
        child: Divider(
          color: Colors.black,
          height: 36,
          thickness: 1.5,
        ),
      ),
    );
  }
}

Widget appBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Center(
      child: Text(
        'BookShelf',
        style: TextStyle(
          fontSize: 40.0,
          fontFamily: 'Dandelion',
          color: Color(0xFFCEF6A0),
        ),
      ),
    ),
  );
}

class BookCard extends StatelessWidget {
  final String author, bookName, imageURL, path;
  BookCard({this.author, this.bookName, this.imageURL, this.path});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage(imageURL),
              width: 80.0,
              height: 110.0,
              fit: BoxFit.fill,
            ),
            SizedBox(
              width: 80.0,
              height: 18.0,
              child: Text(
                bookName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: 70.0,
              child: Text(
                author,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectedBook(
                        title: bookName,
                        path: path,
                      )));
        },
      ),
    );
  }
}

class BookRows extends StatelessWidget {
  final String rowHeading;
  final List<Widget> rowContent;
  final Function onPress;
  BookRows({this.rowHeading, this.rowContent, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 19.0, bottom: 12.0, left: 20.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Text(
                rowHeading,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              GestureDetector(
                child: Text(
                  'SEE MORE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: Color(0xFF02340F),
                  ),
                ),
                onTap: onPress,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rowContent,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}

class GenreCard extends StatelessWidget {
  final String image, cardName, path;
  GenreCard({this.cardName, this.image, this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 22.0, top: 15.0),
        child: Container(
          width: 140.0,
          height: 115.0,
          child: Card(
            elevation: 3.0,
            shape: ContinuousRectangleBorder(side: BorderSide.none),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage('images/' + image),
                  width: 140.0,
                  height: 80.0,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    cardName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GenreBooks(
                      genre: cardName,
                      path: path,
                    )));
      },
    );
  }
}

class BigBookCard extends StatefulWidget {
  final String bookName, path;
  BigBookCard({this.bookName, this.path});

  @override
  _BigBookCardState createState() => _BigBookCardState();
}

class _BigBookCardState extends State<BigBookCard> {

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
        return Padding(
          padding: const EdgeInsets.only(
              top: 10.0, left: 20.0, right: 20.0, bottom: 4.0),
          child: GestureDetector(
            child: Card(
              color: Color(0xFFCEF6A0),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                            child: Text(
                              widget.bookName,
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
                            padding: const EdgeInsets.only(top: 5.0),
                            child: RatingBar.builder(
                              initialRating: 5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 15.0,
                              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.black,
                              ),
                              onRatingUpdate: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectedBook(
                        title: widget.bookName,
                        path: widget.path,
                      )));
            },
          ),
        );
      },
    );
  }
}

class IncompleteBookCard extends StatefulWidget {
  final String bookName, path;
  IncompleteBookCard({this.bookName, this.path});

  @override
  _IncompleteBookCardState createState() => _IncompleteBookCardState();
}

class _IncompleteBookCardState extends State<IncompleteBookCard> {
  String author = "", imageURL = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore
          .collection('Books')
          .doc(widget.path)
          .collection('BookDetails')
          .doc(widget.bookName)
          .snapshots(),
      builder: (context, snapshot) {
        try {
          var variable = snapshot.data.data();
          setState(() {
            imageURL = variable['image'];
            author = variable['author'];
          });
        } catch (e) {
          print(e);
        }
        return Padding(
          padding: const EdgeInsets.only(
              top: 10.0, left: 20.0, right: 20.0, bottom: 4.0),
          child: GestureDetector(
            child: Card(
              color: Color(0xFFCEF6A0),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                            child: Text(
                              widget.bookName,
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
                            padding: const EdgeInsets.only(top: 8.0),
                            child: LinearPercentIndicator(
                              width: 150.0,
                              animation: true,
                              lineHeight: 6.0,
                              animationDuration: 2500,
                              percent: 0.01,
                              trailing: Text(
                                '1%',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.0),
                              ),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Color(0xFF02340F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              if(widget.path == 'Comics') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Book(
                                bookName: widget.bookName,
                                category: widget.path)));
              }
              else{
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BookPage(bookName: widget.bookName, path: widget.path,)));
              }
            },
          ),
        );
      },
    );
  }
}
