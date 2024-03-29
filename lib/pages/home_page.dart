import 'package:amethyst_app/pages/chat.dart';
import 'package:amethyst_app/pages/explore_page/explore.dart';
import 'package:amethyst_app/pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

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
      )
    ];

    return NavBarController(pages: pages);
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

  int _selectedIndex = 1;

  Widget _bottomNavigationBar(int selectedIndex) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            color: Color(0xff3b3b3b)),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onTap: (int index) => setState(() => _selectedIndex = index),
          currentIndex: selectedIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                activeIcon: Image.asset(
                  "assets/chat.png",
                  height: 30,
                  width: 30,
                ),
                icon: Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    "assets/chat.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                title: Text("")),
            BottomNavigationBarItem(
                activeIcon: Image.asset(
                  "assets/explore.png",
                  height: 50,
                  width: 50,
                ),
                icon: Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    "assets/explore.png",
                    height: 50,
                    width: 50,
                  ),
                ),
                title: Text("")),
            BottomNavigationBarItem(
                activeIcon: Image.asset(
                  "assets/face.png",
                  height: 30,
                  width: 30,
                ),
                icon: Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    "assets/face.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                title: Text("")),
          ],
        ),
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
