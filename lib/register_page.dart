//cool_alert: ^1.0.3

import 'dart:async';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_page.dart';
import 'components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookshelf/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';


final _firestore = FirebaseFirestore.instance;


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  String username, email, password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool emailValidate = true, passwordValidate = true, nameValidate = true ;
  User current;
  Timer timer;
  Future<dynamic> coolAlert;

  Future<void> checkEmail() async{
    var user = _auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      await _firestore.collection('users').doc(
                _auth.currentUser.email).set({
              'fullname': username,
              'email': _auth.currentUser.email,
              'profilePic': ""
            });
      setState(() {
        coolAlert = CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: 'Successful',
          text: "Your email has been verified.",
          confirmBtnText: 'Continue',
          confirmBtnColor: Color(0xFF02340F),
          backgroundColor: Color(0xFFCEF6A0),
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => HomePage()));
          }
        );
      });
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> googleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential;
  }

  FacebookLogin fbLogin = new FacebookLogin();

  Future<UserCredential> facebookLogin() async {
    final FacebookLoginResult facebookLoginResult = await fbLogin.logIn(['email', 'public_profile']);
    FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
    AuthCredential authCredential = FacebookAuthProvider.credential(facebookAccessToken.token);
    final UserCredential userCredential = await _auth.signInWithCredential(authCredential);
    return userCredential;
  }

  void validateEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-z0-9]+[\._]?[a-z0-9]+[@]\w+([\.-]?\w+)*(\.\w{2,3})+$');
    if (email.isNotEmpty) {
      if (emailRegex.hasMatch(email))
        setState(() {
          emailValidate = true;
        });
      else
        setState(() {
          emailValidate = false;
        });
    } else
      setState(() {
        emailValidate = false;
      });
  }

  void validatePassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (password.isNotEmpty) {
      if (passwordRegex.hasMatch(password))
        setState(() {
          passwordValidate = true;
        });
      else
        setState(() {
          passwordValidate = false;
        });
    } else
      setState(() {
        passwordValidate = false;
      });
  }

  void validateName(String name) {
    final passwordRegex = RegExp(r'^[a-zA-Z ]*$');
    if (name.isNotEmpty) {
      if (passwordRegex.hasMatch(name))
        setState(() {
          nameValidate = true;
        });
      else
        setState(() {
          nameValidate = false;
        });
    } else
      setState(() {
        nameValidate = false;
      });
  }


  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCEF6A0),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 19.0),
                child: Text(
                  'BookShelf',
                  style: TextStyle(
                    fontSize: 70.0,
                    fontFamily: 'Dandelion',
                    color: Color(0xFF02340F),
                  ),
                ),
              ),
              Container(
                child: Image(
                  image: AssetImage('images/RegisterImage.jpg'),
                  fit: BoxFit.fill,
                  height: 120.0,
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Create Your BookShelf',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 7.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        child: TextField(
                          controller: nameController,
                          decoration: textFieldDecoration.copyWith(
                            hintText: 'Full Name',
                            errorText:
                              nameValidate ? null : 'Incorrect Full name',
                            suffixIcon: Icon(
                              Icons.person,
                              color: Color(0xFF02340F),
                            ),
                          ),
                          onChanged: (value) {
                            username = value;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 7.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFieldDecoration.copyWith(
                              hintText: 'Email ID',
                              errorText:
                                  emailValidate ? null : 'Incorrect Email ID'),
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 7.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: textFieldDecoration.copyWith(
                            hintText: 'Password',
                            errorText: passwordValidate
                                ? null
                                : 'Password must have minimum 8 characters with at least one letter and one number',
                            errorMaxLines: 2,
                            suffixIcon: Icon(
                              Icons.lock,
                              color: Color(0xFF02340F),
                            ),
                          ),
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.0),
                      child: Material(
                        elevation: 5.0,
                        color: Color(0xFF02340F),
                        borderRadius: BorderRadius.circular(30.0),
                        child: RawMaterialButton(
                          onPressed: () async {
                            validateEmail(emailController.text);
                            validatePassword(passwordController.text);
                            validateName(nameController.text);
                            if (emailValidate == true &&
                                passwordValidate == true && nameValidate==true) {
                              try {
                                final newUser =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email, password: password);
                                var user = _auth.currentUser;
                                user.sendEmailVerification();
                                setState(() {
                                  coolAlert = CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.info,
                                    confirmBtnColor: Color(0xFF02340F),
                                    backgroundColor: Color(0xFFCEF6A0),
                                    title: 'Verify',
                                    text: "A verification link has been sent to you account. Click on it to verify your email.",
                                  );
                                });
                                timer = Timer.periodic(Duration(seconds: 3), (timer) {checkEmail(); });
                                 } catch (e) {
                                print(e);
                              }
                            }
                          },
                          padding: EdgeInsets.symmetric(horizontal: 70.0),
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DividerWidget(left: 35.0, right: 15.0),
                        Text(
                          'Or',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DividerWidget(
                          left: 15.0,
                          right: 35.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: SvgPicture.asset(
                            'assets/googleplus.svg',
                            width: 35.0,
                            height: 35.0,
                          ),
                          onTap: () async {
                            UserCredential userCredential =
                                await googleSignIn();
                            User user = userCredential.user;
                            await _firestore.collection('users').doc(user.email).set({'fullname': user.displayName, 'email':user.email, 'profilePic': ""});
                            print(user.displayName);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()), (Route<dynamic> route) => false);
                          },
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        GestureDetector(
                          child: SvgPicture.asset(
                            'assets/facebook.svg',
                            width: 35.0,
                            height: 35.0,
                          ),
                          onTap: () async {
                            UserCredential userCredential =
                            await facebookLogin();
                            User user = userCredential.user;
                            await _firestore.collection('users').doc(user.email).set({'fullname': user.displayName, 'email':user.email, 'profilePic': ""});
                            print(user.displayName);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()), (Route<dynamic> route) => false);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have a BookShelf?',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF02340F),
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              ' Login',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF02340F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
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
      ),
    );
  }
}


class VerifyEmail extends StatefulWidget {

  final email, username;
  final User user;
  VerifyEmail({this.email, this.username, this.user});

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (timer) {checkEmailVerified();});
  }


  Future<void> checkEmailVerified() async {
    await widget.user.reload();
    if(widget.user.emailVerified){
      timer.cancel();
      print(widget.user.emailVerified);
      await _firestore.collection('users').doc(widget.user.email).set({'fullname': widget.username, 'email': widget.user.email});
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()), (Route<dynamic> route) => false);
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(widget.username),
          Text(widget.email),
        ],
      ),
    );
  }
}
