import 'package:flutter/material.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookshelf/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
var currentUserEmail;

class FriendsFragment extends StatefulWidget {
  @override
  _FriendsFragmentState createState() => _FriendsFragmentState();
}

class _FriendsFragmentState extends State<FriendsFragment>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    currentUserEmail = FirebaseAuth.instance.currentUser.email;
    print(currentUserEmail);
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: [
              Tab(
                text: 'Friends',
              ),
              Tab(
                text: 'Requests',
              ),
            ],
          ),
          Container(
            height: screenHeight * 0.70,
            child: TabBarView(
              controller: _tabController,
              children: [
                FriendsTab(),
                RequestTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FriendsTab extends StatefulWidget {
  @override
  _FriendsTabState createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  TextEditingController searchController = TextEditingController();
  bool search = false;
  String searchUser;
  List<Widget> sendList = [];
  List<Widget> friendsList = [];
  var userList = [];

  @override
  void initState() {
    super.initState();
    getFriends();
    getUsers();
    searchController.addListener(_printLatestValue);
  }

  void getUsers() {
    Stream<QuerySnapshot> doc = _firestore.collection('users').snapshots();
    doc.forEach((element) {
      var users = element.docs.asMap();
      for (var key in users.keys) {
        final fullname = element.docs[key]['fullname'];
        setState(() {
          userList.add(fullname);
        });
      }
    });
  }

  void getSearchUsers() {
    Stream<QuerySnapshot> doc = _firestore
        .collection('users')
        .where('fullname', isEqualTo: searchUser)
        .snapshots();
    doc.forEach((element) {
      var users = element.docs.asMap();
      for (var key in users.keys) {
        final email = element.docs[key]['email'];
        final fullname = element.docs[key]['fullname'];
        var book = RequestCardWithOneButton(
          email: email,
        );
        setState(() {
          sendList.add(book);
          userList.add(fullname);
        });
      }
    });
  }

  _printLatestValue() {
    if (searchController.text != "") {
      searchUser = searchController.text;
      getSearchUsers();
      setState(() {
        search = true;
      });
    } else
      search = null;
  }

  void getFriends() {
    friendsList = [];
    Stream<QuerySnapshot> doc =
        _firestore.collection('users/$currentUserEmail/Friends').snapshots();
    doc.forEach((element) {
      var users = element.docs.asMap();
      for (var key in users.keys) {
        final email = element.docs[key]['email'];
        var book = FriendsCard(
          email: email,
        );
        setState(() {
          friendsList.add(book);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextFieldSearch(
                    initialList: userList,
                    label: "Search People",
                    controller: searchController),
              ),
            ),
          ),
          Visibility(
            visible: search ? false : true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 7.0, left: 16.0, top: 20.0),
                  child: Text(
                    'Your Friends',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Column(
                  children: (friendsList.isNotEmpty)
                      ? friendsList
                      : [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'No Friends Currently',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: search ? true : false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 7.0, left: 16.0, top: 20.0),
                      child: Text(
                        'Search Results',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0, top: 20.0),
                        child: SvgPicture.asset(
                          'assets/cancel.svg',
                          width: 20.0,
                          height: 20.0,
                          color: Color(0xFF02340F),
                        ),
                      ),
                      onTap: () {
                        searchController.clear();
                        sendList = [];
                        setState(() {
                          search = false;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: (sendList.isNotEmpty)
                      ? sendList
                      : [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'No User Found',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RequestTab extends StatefulWidget {
  @override
  _RequestTabState createState() => _RequestTabState();
}

class _RequestTabState extends State<RequestTab> {
  List<Widget> acceptList = [];

  @override
  void initState() {
    super.initState();
    getAcceptUsers();
  }

  void getAcceptUsers() {
    acceptList = [];
    Stream<QuerySnapshot> doc = _firestore
        .collection('users/$currentUserEmail/PendingRequests')
        .snapshots();
    doc.forEach((element) {
      var users = element.docs.asMap();
      for (var key in users.keys) {
        final email = element.docs[key]['email'];
        var book = RequestCardWithTwoButtons(
          email: email,
        );
        setState(() {
          acceptList.add(book);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 7.0, left: 16.0, top: 20.0),
            child: Text(
              'Received Requests',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Column(
            children: (acceptList.isNotEmpty)
                ? acceptList
                : [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'No Pending Requests',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

class FriendsCard extends StatefulWidget {
  final String email;
  //final IconData icon;

  FriendsCard({this.email});

  @override
  _FriendsCardState createState() => _FriendsCardState();
}

class _FriendsCardState extends State<FriendsCard> {
  String imageURL = "", name = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(widget.email).snapshots(),
        builder: (context, snapshot) {
          try {
            var variable = snapshot.data.data();
            setState(() {
              name = variable['fullname'];
              imageURL = variable['profilePic'];
            });
          } catch (e) {
            print(e);
          }
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 25.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Color(0xFF02340F),
                        child: (imageURL == null || imageURL == "")
                            ? CircleAvatar(
                                backgroundColor: Color(0xFF02340F),
                                radius: 60,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Color(0xFF02340F),
                                radius: 60,
                                backgroundImage: NetworkImage(
                                  imageURL,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            email: widget.email,
                          )));
            },
          );
        });
  }
}

class RequestCardWithOneButton extends StatefulWidget {
  final String email;

  RequestCardWithOneButton({this.email});

  @override
  _RequestCardWithOneButtonState createState() =>
      _RequestCardWithOneButtonState();
}

class _RequestCardWithOneButtonState extends State<RequestCardWithOneButton> {
  String userName = "", myName = "", profilePic = "";
  bool exists = false;

  @override
  void initState() {
    super.initState();
    //getUser();
    getName();
  }

  // void getUser() {
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

  void getName() {
    Stream<DocumentSnapshot> doc =
        _firestore.doc('users/$currentUserEmail').snapshots();
    doc.forEach((element) {
      setState(() {
        myName = element.data()['fullname'];
      });
    });
  }

  void isSent() async {
    await _firestore
        .doc('users/$currentUserEmail/SentRequests/${widget.email}')
        .get()
        .then((doc) {
      if (doc.exists)
        setState(() {
          exists = true;
        });
      else
        setState(() {
          exists = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    isSent();
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(widget.email).snapshots(),
      builder: (context, snapshot){
        try{
          var variable = snapshot.data.data();
          userName = variable['fullname'];
          profilePic = variable['profilePic'];
        }
        catch(e){
          print(e);
        }
        return Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 15.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Color(0xFF02340F),
                    child: (profilePic == null || profilePic == "")
                        ? CircleAvatar(
                      backgroundColor: Color(0xFF02340F),
                      radius: 60,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    )
                        : CircleAvatar(
                      backgroundColor: Color(0xFF02340F),
                      radius: 60,
                      backgroundImage: NetworkImage(
                        profilePic,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: GestureDetector(
                      child: Material(
                        color: exists ? Color(0xFF505050) : Color(0xFF02340F),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5.0),
                          child: Text(
                            exists ? 'Sent' : 'Send Request',
                            style: TextStyle(fontSize: 12.0, color: Colors.white),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(7.0)),
                      ),
                      onTap: exists
                          ? null
                          : () async {
                        await _firestore
                            .collection('users')
                            .doc(currentUserEmail)
                            .collection('SentRequests')
                            .doc(widget.email)
                            .set({'email': widget.email});
                        await _firestore
                            .collection('users')
                            .doc(widget.email)
                            .collection('PendingRequests')
                            .doc(currentUserEmail)
                            .set({'email': currentUserEmail});
                      },
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

class RequestCardWithTwoButtons extends StatefulWidget {
  final String email;

  RequestCardWithTwoButtons({this.email});

  @override
  _RequestCardWithTwoButtonsState createState() =>
      _RequestCardWithTwoButtonsState();
}

class _RequestCardWithTwoButtonsState extends State<RequestCardWithTwoButtons> {
  String userName = "", myName = "", profilePic = "";
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    //getUser();
    getName();
  }

  // void getUser() {
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

  void getName() {
    Stream<DocumentSnapshot> doc =
        _firestore.doc('users/$currentUserEmail').snapshots();
    doc.forEach((element) {
      setState(() {
        myName = element.data()['fullname'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(widget.email).snapshots(),
      builder: (context, snapshot){
        try{
          var variable = snapshot.data.data();
          userName = variable['fullname'];
          profilePic = variable['profilePic'];
        }
        catch(e){
          print(e);
        }
        return Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 15.0),
          child: Visibility(
            visible: isVisible,
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Color(0xFF02340F),
                      child: (profilePic == null || profilePic == "")
                          ? CircleAvatar(
                        backgroundColor: Color(0xFF02340F),
                        radius: 60,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      )
                          : CircleAvatar(
                        backgroundColor: Color(0xFF02340F),
                        radius: 60,
                        backgroundImage: NetworkImage(
                          profilePic,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        child: Material(
                          color: Color(0xFF02340F),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5.0),
                            child: Text(
                              'Accept',
                              style: TextStyle(fontSize: 12.0, color: Colors.white),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(7.0)),
                        ),
                        onTap: () async {
                          await _firestore
                              .collection('users')
                              .doc(currentUserEmail)
                              .collection('Friends')
                              .doc(widget.email)
                              .set({'email': widget.email});
                          await _firestore
                              .collection('users')
                              .doc(widget.email)
                              .collection('Friends')
                              .doc(currentUserEmail)
                              .set({'email': currentUserEmail});
                          _firestore
                              .collection('users')
                              .doc(currentUserEmail)
                              .collection('PendingRequests')
                              .doc(widget.email)
                              .delete();
                          _firestore
                              .collection('users')
                              .doc(widget.email)
                              .collection('SentRequests')
                              .doc(currentUserEmail)
                              .delete();
                          setState(() {
                            isVisible = false;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                          child: Material(
                            color: Color(0xFF02340F),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5.0),
                              child: Text(
                                'Delete',
                                style:
                                TextStyle(fontSize: 12.0, color: Colors.white),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(7.0)),
                          ),
                          onTap: () {
                            _firestore
                                .collection('users')
                                .doc(currentUserEmail)
                                .collection('PendingRequests')
                                .doc(widget.email)
                                .delete();
                            _firestore
                                .collection('users')
                                .doc(widget.email)
                                .collection('SentRequests')
                                .doc(currentUserEmail)
                                .delete();
                            setState(() {
                              isVisible = false;
                            });
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
