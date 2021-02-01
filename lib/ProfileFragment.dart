import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookshelf/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class ProfileFragment extends StatefulWidget {
  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {

  String name = "";
  @override
  void initState() {
    super.initState();
    getName();
  }
  
  void getName() async {
    Stream<DocumentSnapshot> doc = await _firestore.doc('users/${FirebaseAuth.instance.currentUser.email}').snapshots();
    doc.forEach((element) {
      setState(() {
        name = element.data()['fullname'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(child: Text(name, style: TextStyle(fontSize: 20.0),),
        onTap: () async {
        await FirebaseAuth.instance.signOut();
        final GoogleSignIn googleSignIn = new GoogleSignIn();
        googleSignIn.isSignedIn().then((s) {});
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
        },
      ),
    );
  }
}
