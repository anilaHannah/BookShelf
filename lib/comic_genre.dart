import 'package:flutter/material.dart';
import 'package:bookshelf/components.dart';

class ComicGenre extends StatefulWidget {
  @override
  _ComicGenreState createState() => _ComicGenreState();
}

class _ComicGenreState extends State<ComicGenre> {
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
                'Comic Books',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            Row(
              children: [
                GenreCard(cardName: 'Action', image: 'action.jpg', path: 'Comics',),
                GenreCard(cardName: 'Adventure', image: 'adventure.jpg', path: 'Comics',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Classic', image: 'classic.jpg', path: 'Comics',),
                GenreCard(cardName: 'Comedy', image: 'comedy.jpg', path: 'Comics',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Fantasy', image: 'fantasy.jpg', path: 'Comics',),
                GenreCard(cardName: 'Fiction', image: 'fiction.jpg', path: 'Comics',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Horror', image: 'horror.jpg', path: 'Comics',),
                GenreCard(cardName: 'Mystery', image: 'mystery.jpg', path: 'Comics',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Romance', image: 'romance.jpg', path: 'Comics',),
                GenreCard(cardName: 'Thriller', image: 'thriller.jpg', path: 'Comics',),
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
