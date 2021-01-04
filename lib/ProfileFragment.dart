import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookshelf/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileFragment extends StatefulWidget {
  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(child: Text('profile', style: TextStyle(fontSize: 20.0),),
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
