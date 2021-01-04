import 'package:flutter/material.dart';
import 'package:bookshelf/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookshelf/chat_screen.dart';

class FriendsFragment extends StatefulWidget {
  @override
  _FriendsFragmentState createState() => _FriendsFragmentState();
}

class _FriendsFragmentState extends State<FriendsFragment>
    with TickerProviderStateMixin {
  TabController _tabController;
  bool search = false;

  @override
  void initState() {
    super.initState();
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
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: TextField(
                            obscureText: true,
                            decoration: textFieldDecoration.copyWith(
                              hintText: 'Search People',
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  Icons.search,
                                  color: Color(0xFF02340F),
                                ),
                                onTap: (){
                                  setState(() {
                                    search = true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: search ? false : true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 7.0, left: 16.0, top: 20.0),
                              child: Text(
                                'Your Friends',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            FriendsCard(name: 'Friend 1', icon: Icons.person,),
                            FriendsCard(name: 'Friend 2', icon: Icons.person,),
                            FriendsCard(name: 'Friend 3', icon: Icons.person,),
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
                                    child: SvgPicture.asset('assets/cancel.svg',
                                      width: 20.0,
                                      height: 20.0,
                                      color: Color(0xFF02340F),
                                    ),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      search = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                            RequestCardWithOneButton(name: 'Result 1', icon: Icons.person,),
                            RequestCardWithOneButton(name: 'Result 2', icon: Icons.person,),
                            RequestCardWithOneButton(name: 'Result 3', icon: Icons.person,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 7.0, left: 16.0, top: 20.0),
                        child: Text(
                          'Received Requests',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      RequestCardWithTwoButtons(name: 'Person 1', icon: Icons.person,),
                      RequestCardWithTwoButtons(name: 'Person 2', icon: Icons.person,),
                      RequestCardWithTwoButtons(name: 'Person 3', icon: Icons.person,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FriendsCard extends StatelessWidget {

  final String name;
  final IconData icon;

  FriendsCard({this.name, this.icon});

  @override
  Widget build(BuildContext context) {
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
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30.0,
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
            // Divider(
            //   color: Colors.grey,
            //   height: 36,
            //   thickness: 1.0,
            // ),
          ],
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(image: icon, name: name,)));
      },
    );
  }
}

class RequestCardWithOneButton extends StatelessWidget {

  final String name;
  final IconData icon;

  RequestCardWithOneButton({this.icon, this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 25.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundColor: Color(0xFF02340F),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30.0,
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
              Padding(
                padding: const EdgeInsets.only(left: 90.0),
                child: GestureDetector(
                  child: Material(
                    color: Color(0xFF02340F),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                      child: Text('Send Request', style: TextStyle(fontSize: 12.0, color: Colors.white),),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
                  ),
                  onTap: null,
                ),
              ),
            ],
          ),
          // Divider(
          //   color: Colors.grey,
          //   height: 36,
          //   thickness: 1.0,
          // ),
        ],
      ),
    );
  }
}

class RequestCardWithTwoButtons extends StatelessWidget {

  final String name;
  final IconData icon;

  RequestCardWithTwoButtons({this.icon, this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 25.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundColor: Color(0xFF02340F),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30.0,
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
              Padding(
                padding: const EdgeInsets.only(left: 60.0),
                child: GestureDetector(
                  child: Material(
                    color: Color(0xFF02340F),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                      child: Text('Accept', style: TextStyle(fontSize: 12.0, color: Colors.white),),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
                  ),
                  onTap: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: GestureDetector(
                  child: Material(
                    color: Color(0xFF02340F),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                      child: Text('Delete', style: TextStyle(fontSize: 12.0, color: Colors.white),),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
                  ),
                  onTap: null,
                ),
              ),
            ],
          ),
          // Divider(
          //   color: Colors.grey,
          //   height: 36,
          //   thickness: 1.0,
          // ),
        ],
      ),
    );
  }
}
