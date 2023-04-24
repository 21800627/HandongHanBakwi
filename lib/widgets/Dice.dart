import 'dart:math';

import 'package:flutter/material.dart';

class Dice extends StatefulWidget {
  @override
  _DiceState createState() => _DiceState();
}

class _DiceState extends State<Dice> {
  int _value = 1;
  Offset _offset = Offset.zero;

  void _rollDice() {
    setState(() {
      _value = Random().nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: _offset.dy,
          left: _offset.dx,
          child: Draggable(
            child: SizedBox(
              height: 100,
              child: Image.asset('assets/images/dice.png'),
            ),
            feedback: SizedBox(
              height: 100,
              child: Image.asset('assets/images/dice.png'),
            ),
            childWhenDragging: Container(),
            onDraggableCanceled: (velocity, offset) {
              setState(() {
                _offset = offset;
              });
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: TextButton(
              onPressed: _rollDice,
              child: Text('Roll the Dice'),
            ),
          ),
        ),
      ],
    );
  }
}
