import 'package:amethyst_app/pages/chat.dart';
import 'package:amethyst_app/pages/explore.dart';
import 'package:amethyst_app/pages/profile.dart';
import 'package:amethyst_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key, this.auth, this.user}) : super(key: key);
  final BaseAuth auth;
  final FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      ChatPage(
        key: PageStorageKey("Chat_Page"),
      ),
      ExplorePage(
        key: PageStorageKey("Explore_Page"),
      ),
      ProfilePage(
        key: PageStorageKey("Profile_Page"),
        auth: auth,
      )
    ];

    return Scaffold(
      body: NavBarController(pages: pages),
    );
  }
}

class NavBarController extends StatefulWidget {
  NavBarController({Key key, this.pages}) : super(key: key);

  final List<Widget> pages;

  @override
  _NavBarControllerState createState() => _NavBarControllerState();
}

class _NavBarControllerState extends State<NavBarController> {
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: 30,
              ),
              title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.explore,
                size: 45,
              ),
              title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.portrait,
                size: 30,
              ),
              title: Text("")),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: widget.pages[_selectedIndex],
        bucket: _pageStorageBucket,
      ),
    );
  }
}
