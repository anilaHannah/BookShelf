import 'package:bookshelf/selected_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
String user = '', currentUserEmail = '';

class ChatScreen extends StatefulWidget {
  final String email;

  ChatScreen({this.email});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  String text = '';

  @override
  void initState() {
    super.initState();
    currentUserEmail = FirebaseAuth.instance.currentUser.email;
    user = widget.email;
  }

  // void getEmail() {
  //   Stream<QuerySnapshot> doc = _firestore
  //       .collection('users')
  //       .where('fullname', isEqualTo: widget.name)
  //       .snapshots();
  //   doc.forEach((element) {
  //     var users = element.docs.asMap();
  //     for (var key in users.keys) {
  //       setState(() {
  //         user = element.docs[key]['email'];
  //       });
  //     }
  //   });
  // }

  InputDecoration messageFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
    labelStyle: TextStyle(color: Colors.black),
    hintText: 'Type Message',
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    fillColor: Colors.white,
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 15.0,
    ),
  );

  String name = "", imageURL = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(widget.email).snapshots(),
      builder: (context, snapshot){
        try{
          var variable = snapshot.data.data();
          setState(() {
            name = variable['fullname'];
            imageURL = variable['profilePic'];
          });
        }
        catch(e){
          print(e);
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: GestureDetector(
              onTap: (){
                return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Center(child: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold),)),
                    content: Container(
                      height: 190.0,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 70.0,
                            backgroundColor: Color(0xFF02340F),
                            child: (imageURL == null || imageURL == "")
                                ? CircleAvatar(
                              backgroundColor: Color(0xFF02340F),
                              radius: 70.0,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            )
                                : CircleAvatar(
                              backgroundColor: Color(0xFF02340F),
                              radius: 70.0,
                              backgroundImage: NetworkImage(
                                imageURL,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0,),
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Color(0xFF02340F),
                    child: (imageURL == null || imageURL == "")
                        ? CircleAvatar(
                      backgroundColor: Color(0xFF02340F),
                      radius: 20.0,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    )
                        : CircleAvatar(
                      backgroundColor: Color(0xFF02340F),
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        imageURL,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFFCEF6A0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MessageStream(),
                Container(
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Color(0x20000000),
                    //     offset: Offset(0.0, -1.0),
                    //     blurRadius: 10.0,
                    //   ),
                    // ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: messageTextController,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            onChanged: (value) {
                              text = value;
                            },
                            decoration: messageFieldDecoration.copyWith(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  messageTextController.clear();
                                  var now = DateTime.now();
                                  _firestore
                                      .collection('users')
                                      .doc(currentUserEmail)
                                      .collection('Friends')
                                      .doc(user)
                                      .collection('Messages')
                                      .add({
                                    'time': now,
                                    'text': text,
                                    'sender': currentUserEmail,
                                    'type': 'T'
                                  });
                                  _firestore
                                      .collection('users')
                                      .doc(user)
                                      .collection('Friends')
                                      .doc(currentUserEmail)
                                      .collection('Messages')
                                      .add({
                                    'time': now,
                                    'text': text,
                                    'sender': currentUserEmail,
                                    'type': 'T'
                                  });
                                },
                                child: Icon(
                                  Icons.send,
                                  color: Color(0xFF02340F),
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Material(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5.0),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF02340F),
                              child: SvgPicture.asset(
                                'assets/share.svg',
                                color: Colors.white,
                                width: 20.0,
                                height: 20.0,
                              ),
                              radius: 25.0,
                            ),
                          ),
                        ),
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Center(
                                  child: Text(
                                    "Recommend from your collection",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              content: BookStream(),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("Done"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(currentUserEmail)
          .collection('Friends')
          .doc(user)
          .collection('Messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data.docs;
          List<Widget> messageBubbles = [];
          for (var message in messages) {
            final messageType = message.data()['type'];
            if (messageType == 'T') {
              final messageText = message.data()['text'];
              final messageSender = message.data()['sender'];
              final messageBubble = MessageBubble(
                text: messageText,
                sender: messageSender,
                isMe: currentUserEmail == messageSender,
              );
              messageBubbles.add(messageBubble);
            }
            else{
              final messageText = message.data()['title'];
              final messageSender = message.data()['sender'];
              final path = message.data()['path'];

              final recommendedBubble = RecommendedBookBubble(
                text: messageText,
                sender: messageSender,
                path: path,
                isMe: currentUserEmail == messageSender,
              );
              messageBubbles.add(recommendedBubble);
            }
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
              children: messageBubbles,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender, text;
  final bool isMe;

  MessageBubble({this.sender, this.text, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            elevation: 3.0,
            color: isMe ? Color(0xFFF1EBEB) : Color(0xFFCEF6A0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class BookStream extends StatelessWidget {
  List<RecommendCard> bookList = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users/$currentUserEmail/SavedBooks')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final books = snapshot.data.docs;
          for (var book in books) {
            final bookName = book.data()['bookName'];
            final category = book.data()['category'];

            final bookCard = RecommendCard(
              title: bookName,
              path: category,
            );
            bookList.add(bookCard);
          }
          return Expanded(
            child: ListView(
              children: bookList,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFF02340F),
            ),
          );
        }
      },
    );
  }
}

class RecommendCard extends StatefulWidget {
  final String title, path;

  RecommendCard({this.path, this.title});

  @override
  _RecommendCardState createState() => _RecommendCardState();
}

class _RecommendCardState extends State<RecommendCard> {
  Color color = Colors.transparent;
  bool checkValue = false;
  String author = "", imageURL = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('Books').doc(widget.path).collection('BookDetails').doc(widget.title).snapshots(),
      builder: (context, snapshot){
        try{
          var variable = snapshot.data.data();
          author = variable['author'];
          imageURL = variable['image'];
        }
        catch(e){
          print(e);
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Color(0xFF02340F),
              child: CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(imageURL),
              ),
            ),
            title: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            trailing: Checkbox(
              checkColor: Color(0xFF02340F),
              value: checkValue,
              onChanged: (bool value){
                setState(() {
                  checkValue = value;
                });
                if(value == true){
                  var now = DateTime.now();
                  _firestore
                      .collection('users')
                      .doc(currentUserEmail)
                      .collection('Friends')
                      .doc(user)
                      .collection('Messages')
                      .add({
                    'time': now,
                    'sender': currentUserEmail,
                    'type': 'R',
                    'title': widget.title,
                    'path': widget.path,
                  });
                  _firestore
                      .collection('users')
                      .doc(user)
                      .collection('Friends')
                      .doc(currentUserEmail)
                      .collection('Messages')
                      .add({
                    'time': now,
                    'sender': currentUserEmail,
                    'type': 'R',
                    'title': widget.title,
                    'path': widget.path,
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }
}


class RecommendedBookBubble extends StatefulWidget {
  final String sender, text, path;
  final bool isMe;

  RecommendedBookBubble({this.sender, this.text, this.isMe, this.path});

  @override
  _RecommendedBookBubbleState createState() => _RecommendedBookBubbleState();
}

class _RecommendedBookBubbleState extends State<RecommendedBookBubble> {

  String imageURL = "", author = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('Books').doc(widget.path).collection('BookDetails').doc(widget.text).snapshots(),
      builder: (context, snapshot){
        try{
          var variable = snapshot.data.data();
          setState(() {
            imageURL = variable['image'];
            author = variable['author'];
          });
        }
        catch(e){

        }
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SelectedBook(title: widget.text, path: widget.path)));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
              widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Material(
                  borderRadius: widget.isMe
                      ? BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))
                      : BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  elevation: 3.0,
                  color: widget.isMe ? Color(0xFFF1EBEB) : Color(0xFFCEF6A0),
                  child: SizedBox(
                    width: 260.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isMe ? 'You recommended a book' : 'You got a book recommendation',
                            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                child: Image(
                                  image: NetworkImage(imageURL),
                                  width: 60.0,
                                  height: 90.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 120.0,
                                      child: Text(widget.text,
                                        maxLines: 4,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text('by '+author,
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}