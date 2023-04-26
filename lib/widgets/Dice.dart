import 'dart:math';

import 'package:flutter/material.dart';

class Dice extends StatefulWidget {
  final double left;
  final double top;

  Dice({required this.left, required this.top});

  @override
  _DiceState createState() => _DiceState();
}

class _DiceState extends State<Dice>{
  Offset position = Offset.zero;
  final double boxSize = 50.0;
  final double boundaryLeft = 0.0;
  final double boundaryRight = 200.0;
  final double boundaryTop = 0.0;
  final double boundaryBottom = 200.0;

  int _value = 1;

  // Set the boundaries for the box
  void _handleDrragableCanceled(velocity, offset){
    setState(() {
      double newLeft = offset.dx;
      double newTop = offset.dy;

      if (newLeft < boundaryLeft) {
        newLeft = boundaryLeft;
      } else if (newLeft > boundaryRight) {
        newLeft = boundaryRight - boxSize;
      }

      if (newTop < boundaryTop) {
        newTop = boundaryTop;
      } else if (newTop > boundaryBottom) {
        newTop = boundaryBottom - boxSize;
      }

      _value = Random().nextInt(6) + 1;
      position = Offset(newLeft, newTop);
    });
  }

  @override
  void initState() {
    super.initState();
    position = Offset(widget.left, widget.top);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Draggable(
            feedback: SizedBox(
              height: 100,
              child: Image.asset('assets/images/dicePick.png'),
            ),
            childWhenDragging: Container(),
            onDraggableCanceled: _handleDrragableCanceled,
            child: SizedBox(
              height: 50,
              child: Image.asset('assets/images/dice$_value.png'),
            ),
          ),
        ),
      ],
    );
  }
}
