import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/widgets/Dice.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roll Dice'),
      ),
      body: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.orange,
            ),
          ),
          width: 250,
          height: 250,
          child: Dice(left: 0.0, top: 0.0)
      ),
    );
  }
}