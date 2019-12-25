import 'package:flutter/material.dart';

import 'animation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waves',
      home: Scaffold(
          body: AnimationTest(
        quantity: 2,
        color: Colors.red,
        amplitude: 0.5,
        period: 4,
      )),
    );
  }
}
