import 'dart:math' as Math;

import 'package:flutter/material.dart';

class AnimationTest extends StatefulWidget {
  final int quantity;
  final double amplitude; // >0 && <10
  final double height;
  final double period;
  final Color color;

  AnimationTest({
    this.quantity = 1,
    this.amplitude = 1,
    this.period = 1,
    this.color = Colors.blue,
    this.height,
  });

  @override
  _AnimationTestState createState() => _AnimationTestState();
}

class _AnimationTestState extends State<AnimationTest>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation animation;
  List<Color> colors = [];
  final animDuration = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();

    if (widget.color != null) {
      if (widget.quantity > 1 && widget.quantity < 10) {
        for (int i = 1; i <= widget.quantity; i++) {
          colors.add(widget.color.withOpacity(0.9 - i * 0.1));
        }
      }
    }

    _controller =
        AnimationController(vsync: this, duration: animDuration);
    _controller.addListener(() {});

    animation = Tween(
      begin: 0.0,
      end: Math.pi * 10,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _controller.repeat(period: animDuration);
      }
    });

    _controller.forward();
  }

  _buildWaves() {
    List<Widget> waves = [];
    for (int i = 1; i <= widget.quantity; i++) {
      waves.add(SafeArea(
        child: Container(
          child: CustomPaint(
            painter: TestPainter(
                pi: animation.value,
                color: colors[i - 1],
                period: i*widget.period,
                amplitude: widget.amplitude),
            child: Container(
              height: widget.height,
            ),
          ),
        ),
      ));
    }
    return waves;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: _buildWaves(),
    ));
  }
}

class TestPainter extends CustomPainter {
  final double pi;
  final double period;
  final double amplitude;
  final Color color;
  double viewWidth = 0.0;

  TestPainter({this.pi, this.period, this.color, this.amplitude});

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height - size.height * (1 - amplitude * 0.1);

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color
      ..strokeWidth = 2;
    viewWidth = size.width;

    var path = Path();
    path.moveTo(0, size.height - height * Math.sin(pi) / viewWidth);
    for (int i = 1; i < size.width + 1; i++) {
      path.lineTo(
          i.toDouble(),
          size.height -
              height *
                  (1 + Math.sin(pi * (period*0.1) - i * 2 * Math.pi / viewWidth)) /
                  2);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}
