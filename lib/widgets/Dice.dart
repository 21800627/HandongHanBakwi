import 'dart:math';

import 'package:flutter/material.dart';

class Dice extends StatefulWidget {
  const Dice({Key? key}) : super(key: key);

  @override
  DiceState createState() => DiceState();
}

class DiceState extends State<Dice>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );

  late final Animation<double> _rotation = Tween<double>(
    begin: 0,
    end: 2 * pi,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  int _diceValue = 1;
  double _imageSize = 50;

  Future<int> rollDice() async {
    await _controller.animateTo(0.5, curve: Curves.easeInOutBack);
    int newDiceValue = Random().nextInt(6) + 1;
    setState(() {
      _diceValue = newDiceValue;
    });
    await _controller.animateTo(1.0, curve: Curves.easeOut);
    return newDiceValue;
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotation,
      child: AnimatedBuilder(
        animation: _rotation,
        builder: (context, child) {
          if (_rotation.isCompleted) {
            _imageSize = 50; // Set the image size based on the rotation animation value
          }
          return Image.asset(
            'assets/images/dice$_diceValue.png',
            height: _imageSize,
            width: _imageSize,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
