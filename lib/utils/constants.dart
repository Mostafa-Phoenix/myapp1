import 'package:flutter/material.dart';

const double goldenRatio = 1.618;
const double goldenAngle = 2.399963229728653; // ≈137.5° in radians
const double baseAngularSpeed = 50.0;
const double initialOffset = 10;
const double activationDuration = 2;
const int numberOfOrbs = 21;

final List<Color> activeColors = [
  Colors.red,
  Colors.redAccent,
  Colors.deepOrange,
  Colors.orange,
  Colors.orangeAccent,
  Colors.amber,
  Colors.yellow,
  Colors.lime,
  Colors.lightGreen,
  Colors.green,
  Colors.teal,
  Colors.cyan,
  Colors.lightBlue,
  Colors.blue,
  Colors.blueGrey,
  Colors.indigo,
  Colors.deepPurple,
  Colors.purple,
  Colors.pink,
  Colors.brown,
  Colors.grey,
];