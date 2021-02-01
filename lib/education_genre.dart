import 'package:flutter/material.dart';
import 'package:bookshelf/components.dart';

class EducationGenre extends StatefulWidget {
  @override
  _EducationGenreState createState() => _EducationGenreState();
}

class _EducationGenreState extends State<EducationGenre> {
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
                'Educational Books',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            Row(
              children: [
                GenreCard(cardName: 'Accountancy', image: 'accountancy.jpg', path: 'Educational',),
                GenreCard(cardName: 'Biology', image: 'biology.jpg', path: 'Educational',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Business', image: 'business.jpg', path: 'Educational',),
                GenreCard(cardName: 'Chemistry', image: 'chemistry.jpg', path: 'Educational',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Computer', image: 'computer.jpeg', path: 'Educational',),
                GenreCard(cardName: 'Economics', image: 'economics.jpg', path: 'Educational',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Humanities', image: 'humanities.png', path: 'Educational',),
                GenreCard(cardName: 'Law', image: 'law.jpg', path: 'Educational',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Literature', image: 'literature.jpg', path: 'Educational',),
                GenreCard(cardName: 'Mathematics', image: 'maths.jpg', path: 'Educational',),
              ],
            ),
            Row(
              children: [
                GenreCard(cardName: 'Physics', image: 'physics.png', path: 'Educational',),
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
