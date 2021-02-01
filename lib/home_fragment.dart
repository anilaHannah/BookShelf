import 'package:flutter/material.dart';
import 'package:bookshelf/constants.dart';
import 'package:bookshelf/components.dart';
import 'package:bookshelf/novel_genre.dart';
import 'package:bookshelf/genre_books.dart';
import 'package:bookshelf/comic_genre.dart';
import 'package:bookshelf/education_genre.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  List<Widget> spiritual = [];
  List<Widget> novels = [];
  List<Widget> comics = [];
  List<Widget> educational = [];
  List<Widget> recommended = [];

  String searchBook;
  TextEditingController searchController = TextEditingController();
  List<Widget> searchList = [];
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    getRowBooks('Spiritual', spiritual);
    getRowBooks('Novels', novels);
    getRowBooks('Comics', comics);
    getRowBooks('Educational', educational);
    getRecommended(recommended);
  }

  void getRecommended(List<Widget> list) {
    //int i = 0;
    Stream<QuerySnapshot> doc =
        _firestore.collectionGroup('BookDetails').snapshots();
    doc.forEach((element) {
      var books = element.docs.asMap();
      for (var key in books.keys) {
        final image = element.docs[key]['image'];
        final bookName = element.docs[key]['bookName'];
        final author = element.docs[key]['author'];
        final category = element.docs[key]['category'];
        var book = BookCard(
          author: author,
          bookName: bookName,
          imageURL: image,
          path: category,
        );
        setState(() {
          list.add(book);
          list.shuffle();
        });
      }
    });
  }

  void getRowBooks(String category, List<Widget> list) {
    int i = 0;
    Stream<QuerySnapshot> doc =
        _firestore.collection('Books/$category/BookDetails').snapshots();
    doc.forEach((element) {
      var books = element.docs.asMap();
      for (var key in books.keys) {
        if (i < 6) {
          final image = element.docs[key]['image'];
          final bookName = element.docs[key]['bookName'];
          final author = element.docs[key]['author'];
          var book = BookCard(
            author: author,
            bookName: bookName,
            imageURL: image,
            path: category,
          );
          setState(() {
            list.add(book);
          });
          i++;
        }
      }
    });
  }

  void getSearchBooks() {
    Stream<QuerySnapshot> doc = _firestore
        .collectionGroup('BookDetails')
        .where('bookName', isEqualTo: searchBook)
        .snapshots();
    doc.forEach((element) {
      var books = element.docs.asMap();
      for (var key in books.keys) {
        final image = element.docs[key]['image'];
        final bookName = element.docs[key]['bookName'];
        final author = element.docs[key]['author'];
        final category = element.docs[key]['category'];
        var book = BigBookCard(
          author: author,
          bookName: bookName,
          imageURL: image,
          path: category,
        );
        setState(() {
          searchList.add(book);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 3,
            color: Color(0xFFCEF6A0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 20.0, bottom: 7.0),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: TextField(
                            controller: searchController,
                            decoration: textFieldDecoration.copyWith(
                              hintText: 'Search Books',
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  Icons.search,
                                  color: Color(0xFF02340F),
                                ),
                                onTap: () {
                                  getSearchBooks();
                                  setState(() {
                                    isVisible = false;
                                  });
                                },
                              ),
                            ),
                            onChanged: (value) {
                              searchBook = value;
                            },
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Material(
                        color: Color(0xFFCEF6A0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, right: 8.0),
                          child: CircleAvatar(
                            backgroundColor: Color(0xFF02340F),
                            child: SvgPicture.asset(
                              'assets/microphone.svg',
                              color: Colors.white,
                              width: 20.0,
                              height: 20.0,
                            ),
                            radius: 23.0,
                          ),
                        ),
                      ),
                      onTap: null,
                    ),
                  ],
                ),
                Visibility(
                  visible: isVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 7.0, left: 16.0, top: 10.0),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, left: 7.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CategoryCard(
                          cardText: 'Novel',
                          onPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NovelGenre()));
                          },
                        ),
                        CategoryCard(
                          cardText: 'Education',
                          onPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EducationGenre()));
                          },
                        ),
                        CategoryCard(
                          cardText: 'Comics',
                          onPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ComicGenre()));
                          },
                        ),
                        CategoryCard(
                          cardText: 'Spiritual',
                          onPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GenreBooks(
                                          genre: 'Spiritual Books',
                                          path: 'Spiritual',
                                        )));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Column(
              children: [
                BookRows(
                  rowHeading: 'Recommended for you',
                  rowContent: recommended,
                ),
                BookRows(
                  rowHeading: 'World of Stories',
                  rowContent: novels,
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NovelGenre()));
                  },
                ),
                BookRows(
                  rowHeading: 'Academics Time',
                  rowContent: educational,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EducationGenre()));
                  },
                ),
                BookRows(
                  rowHeading: 'Artistic Comics',
                  rowContent: comics,
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ComicGenre()));
                  },
                ),
                BookRows(
                  rowHeading: 'Get Spiritual',
                  rowContent: spiritual,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GenreBooks(
                                  genre: 'Spiritual',
                                  path: 'Spiritual',
                                )));
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: isVisible ? false : true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 7.0, left: 16.0, top: 20.0),
                      child: Text(
                        'Search Results',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0, top: 20.0),
                        child: SvgPicture.asset(
                          'assets/cancel.svg',
                          width: 20.0,
                          height: 20.0,
                          color: Color(0xFF02340F),
                        ),
                      ),
                      onTap: () {
                        searchController.clear();
                        searchList = [];
                        setState(() {
                          isVisible = true;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: (searchList.isNotEmpty) ? searchList : [
                    Text(
                      'No Book Found',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String cardText;
  final Function onPress;
  CategoryCard({this.cardText, this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 85.0,
        height: 50.0,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
          child: Center(
            child: Text(
              cardText,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      onTap: onPress,
    );
  }
}

class SearchStream extends StatelessWidget {
  final String searchString;
  SearchStream({this.searchString});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collectionGroup('BookDetails')
          .where('bookName', isEqualTo: searchString)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<BigBookCard> list = [];
          final books = snapshot.data.docs;
          for (var book in books) {
            final imageURL = book.data()['image'];
            final bookName = book.data()['bookName'];
            final author = book.data()['author'];
            final category = book.data()['category'];
            final bookCard = BigBookCard(
              imageURL: imageURL,
              bookName: bookName,
              author: author,
              path: category,
            );
            list.add(bookCard);
          }
          return Expanded(
            child: Column(
              children: list,
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
