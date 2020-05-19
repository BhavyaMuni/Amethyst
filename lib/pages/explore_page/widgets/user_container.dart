import 'package:amethyst_app/pages/chat.dart';
import 'package:amethyst_app/styles.dart';
import 'package:amethyst_app/widgets/list_preferences.dart';
import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  const UserContainer(
      {Key key,
      this.bio,
      this.genres,
      this.name,
      this.photoUrl,
      this.instruments,
      this.uid})
      : super(key: key);

  final String name;
  final String uid;
  final List<String> instruments;
  final List<String> genres;
  final String photoUrl;
  final String bio;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20),
      child: GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => ChatWindow(toUid: uid))),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x3e000000),
                  offset: Offset(10, 10),
                  blurRadius: 20,
                ),
                BoxShadow(
                  color: Color(0x1effffff),
                  offset: Offset(-10, -10),
                  blurRadius: 20,
                )
              ],
              borderRadius: BorderRadius.circular(60.0),
              color: Color(0xff3b3b3b)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Color(0x24ffffff),
                      backgroundImage: photoUrl != "" && photoUrl != null
                          ? NetworkImage(photoUrl)
                          : null,
                      radius: 60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    name,
                    style:
                        TextStyles().headerTextStyle().copyWith(fontSize: 28),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "assets/gradient_pin.png",
                        height: 20,
                        width: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Mumbai, India",
                          style: TextStyles()
                              .subheaderTextStyle()
                              .copyWith(color: Colors.white60, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    height: 90,
                    child: Text(
                      bio != null ? bio : "",
                      style: TextStyles()
                          .regularTextStyle()
                          .copyWith(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                ListGenresAndInstruments(
                    editable: false, genres: genres, instruments: instruments),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
