import 'package:flutter/material.dart';

Widget fotmatTitleList(String textTitle) {
  return Text(textTitle,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        height: 1.29,
        textBaseline: TextBaseline.alphabetic,
      ));
}

Widget fotmatTextList(String textBody) {
  return Text(textBody,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 11.0,
        fontWeight: FontWeight.w400,
        height: 1.45,
        textBaseline: TextBaseline.alphabetic,
        color: Color(0x3C3C4399),
      ));
}

Widget warningText(String text) {
  return Text(text,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: Colors.red,
      ));
}
