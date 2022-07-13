import 'package:flutter/material.dart';

const hintStyle = TextStyle(fontWeight: FontWeight.bold);
const normalGreenText = TextStyle(color: Colors.green);
const underlineBoldNormalGreenText = TextStyle(
  shadows: [
    Shadow(
        color: Colors.green,
        offset: Offset(0, -5))
  ],
  color: Colors.transparent,
  decoration:
  TextDecoration.underline,
  fontWeight: FontWeight.bold,
  decorationColor: Colors.green,
  decorationThickness: 1,
);
const normalBlackText = TextStyle(color: Colors.black);

const hintSearchText = TextStyle(color: Colors.grey, fontSize: 14);