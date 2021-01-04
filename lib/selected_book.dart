import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookshelf/components.dart';

class SelectedBook extends StatefulWidget {
  final String author, title, imageURL;
  SelectedBook({this.author, this.imageURL, this.title});

  @override
  _SelectedBookState createState() => _SelectedBookState();
}

class _SelectedBookState extends State<SelectedBook> {

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
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 10.0),
              child: Row(
                children: [
                  Image(
                    image: NetworkImage(widget.imageURL),
                    width: 120.0,
                    height: 190.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 170.0,
                          child: Text(widget.title,
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
                            child: Text('by '+widget.author,
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
                          child: Text('Fantasy | Adventure',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MaterialButton(
                                onPressed: () {},
                                color: Color(0xFF02340F),
                                textColor: Colors.white,
                                child: SvgPicture.asset('assets/save.svg',
                                  width: 16.0,
                                  height: 16.0,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(16),
                                shape: CircleBorder(),
                              ),
                              MaterialButton(
                                onPressed: () {},
                                color: Color(0xFF02340F),
                                textColor: Colors.white,
                                child: SvgPicture.asset('assets/wishlist.svg',
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
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
                    child: Text('About the Book',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0, top: 10.0, right: 28.0),
                    child: SizedBox(
                      width: 200.0,
                      child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam dui enim, ultrices sit amet ligula id, euismod mattis magna. Cras ultricies et libero non mollis. Morbi  in orci risus. Sed ut tellus ipsum. Proin sit amet ultrices tortor. Nullam euismod porta urna, non ornare massa consequat ac. Quisque eu eleifend nisl. Nullam sollicitudin sollicitudin mauris sodales dictum. Etiam inter dum finibus magna. Nam augue elit, viverra sit.',
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
                    rowContent: [
                      BookCard(
                        imageURL: 'https://images-na.ssl-images-amazon.com/images/I/91HHqVTAJQL.jpg',
                        bookName: 'Harry Potter and the chamber of secrets',
                        author: 'J.K Rowling',
                      ),
                    ],
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
