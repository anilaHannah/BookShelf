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
                GenreCard(cardName: 'Action', image: 'action.jpg', path: 'Novels',),
                GenreCard(cardName: 'Adventure', image: 'adventure.jpg', path: 'Novels',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Classic', image: 'classic.jpg', path: 'Novels',),
                GenreCard(cardName: 'Comedy', image: 'comedy.jpg', path: 'Novels',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Fantasy', image: 'fantasy.jpg', path: 'Novels',),
                GenreCard(cardName: 'Fiction', image: 'fiction.jpg', path: 'Novels',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'History', image: 'history.jpg', path: 'Novels',),
                GenreCard(cardName: 'Horror', image: 'horror.jpg', path: 'Novels',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Mystery', image: 'mystery.jpg', path: 'Novels',),
                GenreCard(cardName: 'Poetry', image: 'poetry.jpg', path: 'Novels',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Romance', image: 'romance.jpg', path: 'Novels',),
                GenreCard(cardName: 'Thriller', image: 'thriller.jpg', path: 'Novels',),
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


