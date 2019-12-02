import 'package:amethyst_app/pages/login_page.dart';
import 'package:amethyst_app/pages/sign_up.dart';
import 'package:amethyst_app/services/auth.dart';
import 'package:amethyst_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenrePage();
  }
}

class GenrePage extends StatefulWidget {
  GenrePage({Key key}) : super(key: key);

  @override
  _GenrePageState createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  int _value = 0;
  List<String> genre_list = [
    'Pop',
    'Bollywood',
    'Indian classical',
    'EDM',
    'Hip Hop',
    'Metal',
    'Progressive metal',
    'Djent',
    'Classical',
    'Folk',
    'Fusion',
    'Jazz',
    'Blues',
    'Funk',
    'Neoclassical',
    'Rock',
    'Country',
    'Reggae',
    'Gospel',
    'Orchestral',
    'Flamenco',
    'Indie'
  ];

  List<String> selectedGenres = List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "Select upto 3",
                    style: TextStyles()
                        .headerTextStyle()
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 24),
                  ),
                  Text(
                    "GENRES",
                    style:
                        TextStyles().headerTextStyle().copyWith(fontSize: 24),
                  ),
                ],
              ),
            ),
            Container(
              child: Text(selectedGenres.join(", "),
                  style: TextStyles()
                      .regularTextStyle()
                      .copyWith(color: Colors.white, fontSize: 18)),
            ),
            Container(
              child: Center(
                child: Wrap(
                    spacing: 15,
                    children:
                        List<Widget>.generate(genre_list.length, (int index) {
                      return ChoiceChip(
                        labelPadding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        labelStyle: TextStyles()
                            .regularTextStyle()
                            .copyWith(fontSize: 14, color: Colors.white),
                        backgroundColor: Color(0x00121212),
                        selectedColor: Color(0x00000000),
                        label: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                gradient:
                                    selectedGenres.contains(genre_list[index])
                                        ? TextStyles().baseGrad()
                                        : null,
                                borderRadius: BorderRadius.circular(15.0)),
                            width: 150,
                            child: Center(
                              child: Text(
                                genre_list[index],
                                textAlign: TextAlign.center,
                              ),
                            )),
                        selected: selectedGenres.contains(genre_list[index]),
                        onSelected: (bool selected) {
                          setState(() {
                            if (!selectedGenres.contains(genre_list[index]) &&
                                selectedGenres.length < 3) {
                              selectedGenres.add(genre_list[index]);
                            } else {
                              selectedGenres.remove(genre_list[index]);
                            }
                          });
                        },
                      );
                    }).toList()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FlatButton(
        shape: CircleBorder(),
        child: Icon(
          Icons.navigate_next,
          color: Color(0xffffffff),
          size: 40,
        ),
        onPressed: () {
          saveGenre(selectedGenres);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InstrumentPage()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void saveGenre(List<String> genres) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("genres", genres);
  }
}

class InstrumentPage extends StatefulWidget {
  InstrumentPage({Key key}) : super(key: key);

  @override
  _InstrumentPageState createState() => _InstrumentPageState();
}

class _InstrumentPageState extends State<InstrumentPage> {
  int _value = 0;
  List<String> instrument_list = [
    'Drums',
    'Tabla',
    'Flute',
    'Guitar (Acoustic)',
    'Guitar (Electric)',
    'Bass',
    'Vocals',
    'Guitar (Classical)',
    'Sitar',
    'Sarangi',
    'Santoor',
    'Piano',
    'Keyboard',
    'Brass',
    'Ukulele',
    'Beatbox',
    'Percussion',
    'Violin',
    'Viola',
    'Upright Bass',
    'Cello',
    'Samples',
  ];

  List<String> selectedIntrus = List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Select upto 3",
                  style: TextStyles()
                      .headerTextStyle()
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 24),
                ),
                Text(
                  "INSTRUMENTS",
                  style: TextStyles().headerTextStyle().copyWith(fontSize: 24),
                ),
              ],
            ),
            Container(
              child: Text(selectedIntrus.join(", "),
                  style: TextStyles()
                      .regularTextStyle()
                      .copyWith(color: Colors.white, fontSize: 18)),
            ),
            Container(
              child: Center(
                child: Wrap(
                    spacing: 15,
                    children: List<Widget>.generate(instrument_list.length,
                        (int index) {
                      return ChoiceChip(
                        labelPadding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        labelStyle: TextStyles()
                            .regularTextStyle()
                            .copyWith(fontSize: 14, color: Colors.white),
                        backgroundColor: Color(0x00121212),
                        selectedColor: Color(0x00000000),
                        label: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                gradient: selectedIntrus
                                        .contains(instrument_list[index])
                                    ? TextStyles().baseGrad()
                                    : null,
                                borderRadius: BorderRadius.circular(15.0)),
                            width: 150,
                            child: Center(
                              child: Text(
                                instrument_list[index],
                                textAlign: TextAlign.center,
                              ),
                            )),
                        selected:
                            selectedIntrus.contains(instrument_list[index]),
                        onSelected: (bool selected) {
                          setState(() {
                            if (!selectedIntrus
                                    .contains(instrument_list[index]) &&
                                selectedIntrus.length < 3) {
                              selectedIntrus.add(instrument_list[index]);
                            } else {
                              selectedIntrus.remove(instrument_list[index]);
                            }
                          });
                        },
                      );
                    }).toList()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FlatButton(
        shape: CircleBorder(),
        child: Icon(
          Icons.navigate_next,
          color: Color(0xffffffff),
          size: 40,
        ),
        onPressed: () {
          savenstrument(selectedIntrus.join(", "));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignUpFinalPage()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void savenstrument(String instru) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("instrument", instru);
  }
}

class SignUpFinalPage extends StatefulWidget {
  SignUpFinalPage({Key key}) : super(key: key);

  @override
  _SignUpFinalPageState createState() => _SignUpFinalPageState();
}

class _SignUpFinalPageState extends State<SignUpFinalPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RegisterPage();
  }
}
