import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bookshelf/constants.dart';
import 'package:bookshelf/components.dart';
import 'package:bookshelf/novel_genre.dart';
import 'package:bookshelf/add_book.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: TextField(
                      decoration: textFieldDecoration.copyWith(
                        hintText: 'Search Books',
                        suffixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF02340F),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 7.0, left: 16.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, left: 7.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CategoryCard(cardText: 'Novel',
                          onPress: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NovelGenre()));
                          },
                        ),
                        CategoryCard(cardText: 'Education',
                          onPress: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddBook()));
                          },
                        ),
                        CategoryCard(cardText: 'Comics'),
                        CategoryCard(cardText: 'Mangas'),
                        CategoryCard(cardText: 'Spiritual'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BookRows(
            rowHeading: 'Recommended for you',
            rowContent: [
              BookCard(
                imageURL: 'https://images-na.ssl-images-amazon.com/images/I/91HHqVTAJQL.jpg',
                bookName: 'Harry Potter and the chamber of secrets',
                author: 'J.K Rowling',
              ),
            ],
          ),
          BookRows(
            rowHeading: 'World of Stories',
            rowContent: [
              BookCard(
                imageURL: 'https://images-na.ssl-images-amazon.com/images/I/81yheYBjiuL.jpg',
                bookName: 'Harry Potter and the order of phoenix',
                author: 'J.K Rowling',
              ),
            ],
            onPress: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NovelGenre()));
            },
          ),
          BookRows(
            rowHeading: 'Academics Time',
            rowContent: [
              BookCard(
                imageURL: 'https://zbook.org/img/2010/python-basics-sample-chapters.jpg',
                bookName: 'Python Basics: A Practical Introduction to Python 3',
                author: 'David Amos, Dan Bader',
              ),
            ],
          ),
          BookRows(
            rowHeading: 'Artistic Comics',
            rowContent: [
              BookCard(
                imageURL: 'https://m.media-amazon.com/images/I/514g8Sc-DmL.jpg',
                bookName: 'Marvelous Myths: Marvel Superheroes and Everyday Faith',
                author: 'Russell Dalton',
              ),
            ],
          ),
          BookRows(
            rowHeading: 'Original Mangas',
            rowContent: [
              BookCard(
                imageURL: 'https://upload.wikimedia.org/wikipedia/en/thumb/9/94/NarutoCoverTankobon1.jpg/220px-NarutoCoverTankobon1.jpg',
                bookName: 'Naruto',
                author: 'Masashi Kishimoto',
              ),
            ],
          ),
          BookRows(
            rowHeading: 'Get Spiritual',
            rowContent: [
              BookCard(
                imageURL: 'https://s.pdfdrive.com/assets/thumbs/b66/b66b70cf4e23d9910dde69ef351aae45.jpg',
                bookName: 'The Power of Now: A Guide to Spiritual Enlightenment',
                author: 'Eckhart Tolle',
              ),
            ],
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
        width: 130.0,
        height: 60.0,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
          child: Center(
            child: Text(
              cardText,
              style: TextStyle(
                fontSize: 15.0,
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
