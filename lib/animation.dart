import 'dart:math' as Math;

import 'package:flutter/material.dart';

class AnimationTest extends StatefulWidget {
  @override
  _AnimationTestState createState() => _AnimationTestState();
}

class _AnimationTestState extends State<AnimationTest>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _controller.addListener(() {});

    animation = Tween(
      begin: 0.0,
      end: Math.pi * 5,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _controller.repeat();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomPaint(
      painter: TestPainter(pi: animation.value),
      child: Container(
        height: 240,
      ),
    ));
  }
}

class TestPainter extends CustomPainter {
  final double pi;

  TestPainter({this.pi});

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;

    canvas.translate(0, height);

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue
      ..strokeWidth = 2;

    var path = Path();
    path.moveTo(0, size.height * 0.75 - height * Math.sin(pi) / 4);
    var A = Offset(size.width * 0.33,
        size.height * 0.75 - height * Math.sin(pi - Math.pi / 3) / 4);
    var B = Offset(size.width * 0.66,
        size.height * 0.75 - height * Math.sin(pi - 2 * Math.pi / 3) / 4);
    var C = Offset(size.width * 1.0,
        size.height * 0.75 - height * Math.sin(pi - 3 * Math.pi) / 4);

//
    path.cubicTo(A.dx, A.dy, B.dx, B.dy, C.dx, C.dy);

//
//    path.quadraticBezierTo(A.dx, A.dy, B.dx, B.dy);
//    path.quadraticBezierTo(C.dx, C.dy, D.dx, D.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}
