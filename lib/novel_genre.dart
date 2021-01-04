import 'package:flutter/material.dart';
import 'package:bookshelf/components.dart';
import 'package:bookshelf/novel_genre.dart';

class NovelGenre extends StatefulWidget {
  @override
  _NovelGenreState createState() => _NovelGenreState();
}

class _NovelGenreState extends State<NovelGenre> {


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
                'Novel & Stories',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            Row(
              children: [
                GenreCard(cardName: 'Action', image: 'action.jpg',),
                GenreCard(cardName: 'Adventure', image: 'adventure.jpg',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Classic', image: 'classic.jpg',),
                GenreCard(cardName: 'Comedy', image: 'comedy.jpg',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Fantasy', image: 'fantasy.jpg',),
                GenreCard(cardName: 'Fiction', image: 'fiction.jpg',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'History', image: 'history.jpg',),
                GenreCard(cardName: 'Horror', image: 'horror.jpg',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Mystery', image: 'mystery.jpg',),
                GenreCard(cardName: 'Poetry', image: 'poetry.jpg',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Romance', image: 'romance.jpg',),
                GenreCard(cardName: 'Thriller', image: 'thriller.jpg',),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}


