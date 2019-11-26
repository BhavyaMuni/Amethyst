import 'package:amethyst_app/pages/login_page.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(selectedGenres.join(", ")),
          Wrap(
              children: List<Widget>.generate(genre_list.length, (int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChoiceChip(
                labelPadding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                labelStyle: TextStyles()
                    .regularTextStyle()
                    .copyWith(fontSize: 18, color: Colors.white),
                backgroundColor: Color(0x006597ef),
                selectedColor: Color(0xff6597ef),
                label: Text(genre_list[index]),
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
              ),
            );
          }).toList()),
          FloatingActionButton(
            onPressed: () {
              saveGenre(selectedGenres);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InstrumentPage(
                            genreCtx: context,
                          )));
            },
          )
        ],
      ),
    );
  }

  void saveGenre(List<String> genres) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("genres", genres);
  }
}

class InstrumentPage extends StatefulWidget {
  InstrumentPage({Key key, this.genreCtx}) : super(key: key);

  final BuildContext genreCtx;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(instrument_list[_value]),
          Wrap(
              children:
                  List<Widget>.generate(instrument_list.length, (int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChoiceChip(
                label: Text(instrument_list[index]),
                selected: _value == index,
                onSelected: (bool selected) {
                  setState(() {
                    _value = selected ? index : null;
                  });
                },
              ),
            );
          }).toList()),
          FloatingActionButton(
            onPressed: () {
              savenstrument(instrument_list[_value]);
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return SignUpFinalPage(
                    genreCtx: widget.genreCtx, instruCtx: context);
              }));
            },
          )
        ],
      ),
    );
  }

  void savenstrument(String instru) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("instrument", instru);
  }
}

class SignUpFinalPage extends StatefulWidget {
  SignUpFinalPage({Key key, this.genreCtx, this.instruCtx}) : super(key: key);

  final BuildContext genreCtx;
  final BuildContext instruCtx;

  @override
  _SignUpFinalPageState createState() => _SignUpFinalPageState();
}

class _SignUpFinalPageState extends State<SignUpFinalPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LoginForm(
      auth: new Auth(),
      isLogin: false,
      ctxs: [widget.genreCtx, widget.instruCtx, context],
    );
  }
}
