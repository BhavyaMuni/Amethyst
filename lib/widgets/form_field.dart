import 'package:amethyst_app/styles.dart';
import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String text;
  final String hintText;
  final Function(String) cb;
  final String initVal;
  const FormTextField(
      {Key key, this.hintText, this.text, this.cb, this.initVal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          text + ": ",
          style: TextStyles()
              .subheaderTextStyle()
              .copyWith(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.left,
        ),
        Container(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: Color(0x44000000)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              maxLines: text.toLowerCase() == "bio" ? 7 : 1,
              initialValue: initVal != null ? initVal : null,
              validator: (val) => val.isEmpty ? text + "can\'t be empty" : null,
              onSaved: (val) => this.cb(val.trim()),
              textAlign: TextAlign.left,
              style: TextStyles()
                  .regularTextStyle()
                  .copyWith(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: this.hintText),
            ),
          ),
        ),
      ]),
    );
  }
}
