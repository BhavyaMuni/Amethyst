import 'package:flutter/material.dart';

class TextStyles {
  final baseTextStyle = const TextStyle(fontFamily: 'Nunito');

  LinearGradient baseGrad() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [0.0, 1.0],
      colors: <Color>[Color(0xffB339F6), Color(0xff6597ef)],
    );
  }

  TextStyle headerTextStyle() {
    return baseTextStyle.copyWith(
        color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600);
  }

  TextStyle smallheaderTextStyle() {
    return baseTextStyle.copyWith(
        color: Color(0xffb339f6), fontSize: 12.0, fontWeight: FontWeight.w600);
  }

  TextStyle regularTextStyle() {
    return baseTextStyle.copyWith(
        color: Color(0xff000000), fontSize: 9.0, fontWeight: FontWeight.w400);
  }

  TextStyle subheaderTextStyle() {
    return baseTextStyle.copyWith(
        color: Color(0xffb339f6), fontSize: 12.0, fontWeight: FontWeight.w400);
  }
}
