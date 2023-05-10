import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/widgets/Dice.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen>{

  final GlobalKey<DiceState> diceKey = GlobalKey<DiceState>();

  void _rollDiceButton() async {
    await diceKey.currentState?.rollDice().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roll Dice'),
      ),
      body: Container(
          margin: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Dice(key: diceKey,)
              ),
              ElevatedButton(
                onPressed: _rollDiceButton,
                child: const Text('Roll Dice'),
              )
            ],
          ),
      ),
    );
  }
}
