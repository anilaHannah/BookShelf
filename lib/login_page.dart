import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'register_page.dart';
import 'components.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

//final _firestore = FirebaseFirestore.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;
  final _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool emailValidate = true, passwordValidate = true;
  bool showSpinner = false;

  final GoogleSignIn _googleSignIn = new GoogleSignIn();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCEF6A0),
      body: ModalProgressHUD(
        color: Color(0xFF02340F),
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    'BookShelf',
                    style: TextStyle(
                      fontSize: 80.0,
                      fontFamily: 'Dandelion',
                      color: Color(0xFF02340F),
                    ),
                  ),
                ),
                Container(
                  child: Image(
                    image: AssetImage('images/LoginImage.jpg'),
                  ),
                  margin: EdgeInsets.only(left: 30.0, right: 30.0),
                ),
                SizedBox(
                  height: 23.0,
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
                          'Go To Your BookShelf',
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
                                )),
                            onChanged: (value) {
                              password = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          elevation: 5.0,
                          color: Color(0xFF02340F),
                          borderRadius: BorderRadius.circular(30.0),
                          child: RawMaterialButton(
                            onPressed: () async {
                              validateEmail(emailController.text);
                              validatePassword(passwordController.text);
                              if (emailValidate == true &&
                                  passwordValidate == true) {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  final user =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  if (user != null) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()), (Route<dynamic> route) => false);
                                  } else
                                    print('Null user');
                                } catch (e) {
                                  print(e);
                                  Future<dynamic> coolAlert = CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    confirmBtnColor: Color(0xFF02340F),
                                    backgroundColor: Color(0xFFCEF6A0),
                                    title: 'Error',
                                    text: e.toString(),
                                  );
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  // return showDialog(
                                  //   context: context,
                                  //   builder: (ctx) => AlertDialog(
                                  //     title: Text("Login Error", style: TextStyle(fontWeight: FontWeight.bold),),
                                  //     content: Text(e.toString()),
                                  //     actions: <Widget>[
                                  //       FlatButton(
                                  //         onPressed: () {
                                  //           Navigator.of(ctx).pop();
                                  //           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
                                  //         },
                                  //         child: Text("OK"),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // );
                                }
                              }
                            },
                            padding: EdgeInsets.symmetric(horizontal: 70.0),
                            child: Text(
                              'LOGIN',
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
                      SizedBox(
                        height: 7.0,
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
                              UserCredential userCredential = await googleSignIn();
                              if (userCredential != null) {
                                User user = userCredential.user;
                                print(user.displayName);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()), (Route<dynamic> route) => false);
                              }
                              else
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("No Such User", style: TextStyle(fontWeight: FontWeight.bold),),
                                    content: Text("You haven\'t registered to BookSelf."),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
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
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New to BookShelf?',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF02340F),
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                ' Register Now',
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
                                        builder: (context) => RegisterPage()));
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
      ),
    );
  }
}
