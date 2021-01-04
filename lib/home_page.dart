import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookshelf/components.dart';
import 'package:bookshelf/home_fragment.dart';
import 'package:bookshelf/friends_fragment.dart';
import 'package:bookshelf/currentbooks_fragment.dart';
import 'package:bookshelf/ProfileFragment.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {

  int selectedIndex = 1;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final fragment = [CurrentBooksFragment(), HomeFragment(), FriendsFragment(), ProfileFragment(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/open-book.svg',
              width: 20.0,
              height: 20.0,
              color: Color(0xFF02340F),
            ),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/home.svg',
              width: 20.0,
              height: 20.0,
              color: Color(0xFF02340F),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/friends.svg',
              width: 20.0,
              height: 20.0,
              color: Color(0xFF02340F),
            ),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Color(0xFF02340F),
              size: 25.0,
            ),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.shifting,
        elevation: 20,
        selectedFontSize: 12.0,
        selectedItemColor: Colors.black,
        onTap: (index){
          setState(() {
            widget.selectedIndex = index;
          });
        },
        currentIndex: widget.selectedIndex,
      ),
      body: fragment[widget.selectedIndex],
    );
  }
}
