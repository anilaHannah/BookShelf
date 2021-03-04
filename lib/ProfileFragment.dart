import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookshelf/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'constants.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:bookshelf/wishlist.dart';

String username = '!', email = '' ,imageURL = '';

//final _firestore = FirebaseFirestore.instance;

class ProfileFragment extends StatefulWidget {
  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {

  String name = "";
  @override
  void initState() {
    super.initState();
    email = FirebaseAuth.instance.currentUser.email;
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImage(true);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImage(false);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<String> uploadProPic(File image) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profilePics/${Path.basename(_image.path)}');
    UploadTask uploadTask = storageReference.putFile(_image);
    String returnURL;
    var url = await(await uploadTask).ref.getDownloadURL();
    returnURL = url.toString();
    return returnURL;
  }

  TextEditingController usernameController = new TextEditingController();
  File _image;

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery
    if(gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,);
    }
    // Otherwise open camera to get new photo
    else{
      pickedFile = await picker.getImage(
        source: ImageSource.camera,);
    }

    setState(() async{
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageURL = await uploadProPic(_image);
        CollectionReference user = FirebaseFirestore.instance.collection('users');
        user.doc(email).update({'profilePic': imageURL});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(email).snapshots(),
            builder: (context,snapshot){
              var variable = snapshot.data;
              print(variable);
              try{
                username = snapshot.data['fullname'];
                usernameController.text = username;
                //email = FirebaseAuth.instance.currentUser.email;
                imageURL = variable['profilePic'];
                //imageURL = variable['profilePic'];
                print(variable);
              }
              catch (e){
                print('Profile pic not made yet');
              }
              return Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('Your Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),),
                    ),
                    Center(
                      child: imageURL == "" ?
                      CircleAvatar(
                          backgroundColor: Color(0xFF02340F),
                          radius: 60,
                          child: Text(username[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Color(0xFFCEF6A0),),
                          ))
                          : CircleAvatar(
                        backgroundColor: Color(0xFF02340F),
                        radius: 60,
                        backgroundImage: NetworkImage(imageURL,),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Center(
                      child: GestureDetector(
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF02340F),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                        onTap: (){_showPicker(context);},
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        width: 250,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: usernameController,
                          decoration: textFieldDecoration.copyWith(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                            hintText: 'Username',
                            suffixIcon: Icon(
                              Icons.edit,
                              color: Color(0xFF02340F),
                            ),
                          ),
                          onChanged: (value) {
                            username = value;
                            FirebaseFirestore.instance.collection('users').doc(email).update({
                              'fullname': value,
                            });
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 200,
                        child: Text(email,
                          textAlign: TextAlign.center,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:[
                          GestureDetector(
                            child: Container(
                              height: 120.0,
                              width: 120.0,
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF02340F),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                child: Column(
                                  children: [
                                    Padding(padding: EdgeInsets.fromLTRB(5, 15, 5, 20),
                                      child: SvgPicture.asset(
                                        'assets/wishlist2.svg',
                                        color: Colors.white,
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                                    ),
                                    new Center(
                                      child: new Text("View Wishlist",
                                        style: TextStyle(fontSize: 12, color: Colors.white),
                                        textAlign: TextAlign.center,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WishList()));
                            },
                          ),
                          Container(
                            height: 120.0,
                            width: 120.0,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF02340F),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: Column(
                                children: [
                                  Padding(padding: EdgeInsets.fromLTRB(5, 15, 5, 20),
                                    child: SvgPicture.asset(
                                      'assets/bookshelf.svg',
                                      color: Colors.white,
                                      width: 40.0,
                                      height: 40.0,
                                    ),
                                  ),
                                  new Center(
                                    child: new Text("View BookShelf",
                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                      textAlign: TextAlign.center,),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: GestureDetector(
                        onTap: (){},
                        child: Material(
                          elevation: 5.0,
                          color: Color(0xFF02340F),
                          borderRadius: BorderRadius.circular(10.0),
                          child: RawMaterialButton(
                            onPressed: () async{
                              await FirebaseAuth.instance.signOut();
                              final GoogleSignIn googleSignIn = new GoogleSignIn();
                              googleSignIn.isSignedIn().then((s) {});
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
                            },
                            padding: EdgeInsets.symmetric(horizontal: 100.0),
                            child: Text(
                              'LOGOUT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
    );
  }
}








