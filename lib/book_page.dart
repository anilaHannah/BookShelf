import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

var currentUserEmail;

double fontSize;
ThemeData theme = ThemeData.light();

var translateLanguage;
var translatedText = "";
String selectedText = "";
var dictionaryText = "";
var audio = "";
var pronunciation = "";

var book = "";
var bookPath = "";

var languages = [
  'English',
  'Hindi',
  'Malayalam',
  'Tamil',
  'French',
  'German',
  'Korean',
  'Japanese',
  'Spanish',
  'Arabic',
  'Russian',
  'Portuguese'
];
var languageCodes = [
  'en',
  'hi',
  'ml',
  'ta',
  'fr',
  'de',
  'ko',
  'ja',
  'es',
  'ar',
  'ru',
  'pt-PT'
];

class BookPage extends StatefulWidget {
  final String bookName, path;
  BookPage({this.bookName, this.path});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> with TickerProviderStateMixin {
  String bookText = 'BookText';
  bool isVisible = false;
  TabController _tabController;
  final messageTextController = TextEditingController();

  String text = '';

  InputDecoration messageFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
    labelStyle: TextStyle(color: Colors.black),
    hintText: 'Comment Here',
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

  @override
  void initState() {
    super.initState();
    loadText();
    fontSize = 14.0;
    _tabController = new TabController(length: 2, vsync: this);
    currentUserEmail = _auth.currentUser.email;
    book = widget.bookName;
    bookPath = widget.path;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void loadText() async {
    String text = await rootBundle.loadString('assets/DeathontheNile.txt');
    setState(() {
      bookText = text;
    });
  }

  void setTranslate(String text) async {
    final translator = GoogleTranslator();
    var temp = await translator.translate(selectedText, to: 'ml');
    setState(() {
      translatedText = temp.text;
    });
    print(translatedText);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: (theme == ThemeData.light())
              ? Color(0xFF02340F)
              : Colors.transparent,
          title: Text(
            'Death on the Nile',
            style: TextStyle(
              fontSize: 20.0,
              color: Color(0xFFCEF6A0),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (bookText == 'BookText')
                        ? Center(
                            child: CircularProgressIndicator(
                            backgroundColor: Color(0xFF02340F),
                          ))
                        : SelectableText(
                            bookText,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: fontSize,
                            ),
                            toolbarOptions: ToolbarOptions(
                                copy: false,
                                paste: false,
                                cut: false,
                                selectAll: false),
                            onSelectionChanged: (text, cause) {
                              print(text.end - text.start);
                              if ((text.end - text.start) > 1)
                                setState(() {
                                  isVisible = true;
                                  selectedText =
                                      bookText.substring(text.start, text.end);
                                });
                              else {
                                setState(() {
                                  isVisible = false;
                                });
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isVisible,
              child: Positioned(
                bottom: 50.0,
                left: 90.0,
                child: Container(
                  color: Colors.black,
                  child: Row(
                    children: [
                      RaisedButton(
                        color: Colors.black,
                        child: Text(
                          'Translate',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Center(
                                child: Text(
                                  "Translate",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              content: Translate(),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    translatedText = "";
                                    translateLanguage = null;
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        child: SizedBox(
                          width: 1.0,
                        ),
                      ),
                      RaisedButton(
                        color: Colors.black,
                        child: Text(
                          'Dictionary',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Center(
                                child: Text(
                                  "Dictionary",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              content: Dictionary(),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    dictionaryText = "";
                                    audio = "";
                                    pronunciation = "";
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SlidingUpPanel(
              minHeight: 20.0,
              maxHeight: 400.0,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
              panel: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: 'Settings',
                      ),
                      Tab(
                        text: 'Comments',
                      ),
                    ],
                  ),
                  Container(
                    height: screenHeight * 0.50,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0, bottom: 4.0, left: 20.0),
                              child: Text(
                                'Font Size',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Slider(
                              value: fontSize,
                              min: 12.0,
                              max: 40.0,
                              label: fontSize.toString(),
                              activeColor: Color(0xFF02340F),
                              inactiveColor: Colors.grey,
                              onChanged: (value) {
                                setState(() {
                                  fontSize = value.ceilToDouble();
                                  print(fontSize);
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0, bottom: 10.0, left: 20.0),
                              child: Text(
                                'Theme',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Material(
                                      color: Colors.white,
                                      elevation: 3.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            theme = ThemeData.light();
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: SvgPicture.asset(
                                                  'assets/daymode.svg',
                                                  width: 50.0,
                                                  height: 50.0,
                                                  color: Color(0xFF02340F),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Text(
                                                'Day Mode',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30.0,
                                  ),
                                  Expanded(
                                    child: Material(
                                      color: Colors.white,
                                      elevation: 3.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            theme = ThemeData.dark();
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: SvgPicture.asset(
                                                  'assets/nightmode.svg',
                                                  width: 50.0,
                                                  height: 50.0,
                                                  color: Color(0xFF02340F),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Text(
                                                'Night Mode',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(left: 8.0, right: 8.0),
                                          child: TextField(
                                            controller: messageTextController,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            onChanged: (value) {
                                              text = value;
                                            },
                                            decoration:
                                            messageFieldDecoration.copyWith(
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  messageTextController.clear();
                                                  var now = DateTime.now();
                                                  _firestore
                                                      .collection('Books')
                                                      .doc(widget.path)
                                                      .collection('BookDetails')
                                                      .doc(widget.bookName)
                                                      .collection('Comments')
                                                      .add({
                                                    'time': now,
                                                    'comment': text,
                                                    'sender': currentUserEmail,
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
                                    ],
                                  ),
                                ),
                              ),
                              MessageStream(),
                            ],
                          ),
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
    );
  }
}


class Translate extends StatefulWidget {
  @override
  _TranslateState createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190.0,
      child: Column(
        children: [
          Text(
            selectedText,
            maxLines: 3,
            style: TextStyle(fontSize: 16.0),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
            child: Container(
              width: 350.0,
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: languages.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Text(dropDownStringItem),
                          ));
                    }).toList(),
                    hint: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        'Translate to',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    onChanged: (String newValueSelected) {
                      setState(() {
                        translateLanguage = newValueSelected;
                      });
                      final translator = GoogleTranslator();
                      translator
                          .translate(selectedText,
                              to: languageCodes[
                                  languages.indexOf(newValueSelected)])
                          .then((value) {
                        setState(() {
                          translatedText = value.text;
                          print(translatedText);
                        });
                      });
                    },
                    value: translateLanguage,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Translation: ' + translatedText.toString(),
              style: TextStyle(fontSize: 18.0, fontFamily: 'NotoSans'),
              maxLines: 3,
            ),
          )
        ],
      ),
    );
  }
}

class Dictionary extends StatefulWidget {
  @override
  _DictionaryState createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    Networking networking = Networking(
        url:
            'https://api.dictionaryapi.dev/api/v2/entries/en_US/$selectedText');
    var wordData = await networking.getWordData();
    if (wordData != null) {
      setState(() {
        pronunciation = wordData[0]['phonetics'][0]['text'];
        audio = wordData[0]['phonetics'][0]['audio'];
        dictionaryText =
            wordData[0]['meanings'][0]['definitions'][0]['definition'];
        print(dictionaryText);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 20.0,
                    child: Icon(
                      Icons.volume_up,
                      color: Color(0xFF02340F),
                      size: 20.0,
                    ),
                  ),
                  onTap: () {
                    AudioPlayer audioPlayer = AudioPlayer();
                    audioPlayer.play(audio);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SizedBox(
                    width: 160.0,
                    child: Text(
                      selectedText,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            pronunciation,
            style: TextStyle(fontSize: 12.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              dictionaryText,
              style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class Networking {
  final String url;
  Networking({this.url});

  Future getData() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      return decodedData;
    } else
      print(response.statusCode);
  }

  Future<dynamic> getWordData() async {
    var bookData = await getData();
    return bookData;
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Books')
          .doc(bookPath)
          .collection('BookDetails')
          .doc(book)
          .collection('Comments')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data.docs;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data()['comment'];
            final messageSender = message.data()['sender'];

            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: currentUserEmail == messageSender,
            );
            messageBubbles.add(messageBubble);
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

class MessageBubble extends StatefulWidget {
  final String sender, text;
  final bool isMe;

  MessageBubble({this.sender, this.text, this.isMe});

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {

  String username = "", profilePic = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(widget.sender).snapshots(),
      builder: (context, snapshot){
        try{
          var variable = snapshot.data.data();
          username = variable['fullname'];
          profilePic = variable['profilePic'];
        }
        catch(e){
          print(e);
        }
        return Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(fontSize: 10.0, color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 3.0),
                    child: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: Color(0xFF02340F),
                      child: (profilePic == null || profilePic == "")
                          ? CircleAvatar(
                        backgroundColor: Color(0xFF02340F),
                        radius: 15.0,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 15.0,
                        ),
                      )
                          : CircleAvatar(
                        backgroundColor: Color(0xFF02340F),
                        radius: 15.0,
                        backgroundImage: NetworkImage(
                          profilePic,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: Text(
                      '${widget.text}',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
