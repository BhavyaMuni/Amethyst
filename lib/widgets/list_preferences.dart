import 'package:amethyst_app/styles.dart';
import 'package:amethyst_app/widgets/prefs_popup.dart';
import 'package:flutter/material.dart';

class ListGenresAndInstruments extends StatefulWidget {
  final List instruments;
  final List genres;
  final bool editable;
  const ListGenresAndInstruments(
      {Key key, this.instruments, this.genres, this.editable})
      : super(key: key);

  @override
  ListGenresAndInstrumentsState createState() =>
      ListGenresAndInstrumentsState();
}

class ListGenresAndInstrumentsState extends State<ListGenresAndInstruments> {
  List instruments;
  List genres;

  List<String> instrumentList = [
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
  List<String> genreList = [
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genres = widget.genres;
    instruments = widget.instruments;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widget.editable
            ? listTitlesEdit("Genres", genres, changeGenres, genreList)
            : listTitles("Genres", genres),
        widget.editable
            ? listTitlesEdit(
                "Instruments", instruments, changeInstruments, instrumentList)
            : listTitles("Instruments", instruments)
      ],
    );
  }

  changeGenres(newVals) {
    setState(() {
      genres = newVals;
    });
  }

  changeInstruments(newVals) {
    setState(() {
      instruments = newVals;
    });
  }

  BoxDecoration editingDecor() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Color(0x3e000000),
        offset: Offset(6, 6),
        blurRadius: 10,
      ),
      BoxShadow(
        color: Color(0x1effffff),
        offset: Offset(-6, -6),
        blurRadius: 10,
      )
    ], borderRadius: BorderRadius.circular(50.0), color: Color(0xff3b3b3b));
  }

  Widget listTitles(String titleHead, List<String> list) {
    return Expanded(
      child: Padding(
        padding: widget.editable
            ? const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30)
            : EdgeInsets.zero,
        child: Container(
          decoration: widget.editable ? editingDecor() : null,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: <Widget>[
                Text(titleHead,
                    style: TextStyles()
                        .headerTextStyle()
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: listOut(list),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listTitlesEdit(String titleHead, List<String> list,
      Function(List<String>) cb, List displayVal) {
    return Expanded(
      child: GestureDetector(
        onTap: () => showDialog(
            context: context,
            builder: (ctx) => EditPreferencesPopup(
                  callback: cb,
                  valueToDisplay: displayVal,
                  initValue: list,
                )),
        child: Padding(
          padding: widget.editable
              ? const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30)
              : EdgeInsets.zero,
          child: Container(
            decoration: widget.editable ? editingDecor() : null,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: <Widget>[
                  Text(titleHead,
                      style: TextStyles()
                          .headerTextStyle()
                          .copyWith(fontSize: 18)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: listOut(list),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listOut(List<String> list) {
    return Container(
      height: 70,
      child: Center(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(
                  child: Text(list[index],
                      textAlign: TextAlign.center,
                      style: TextStyles().regularTextStyle().copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300))),
            );
          },
        ),
      ),
    );
  }
}
