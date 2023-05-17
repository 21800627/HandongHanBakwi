import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/models/QUESTION.dart';

import '../models/BOARD.dart';
import '../widgets/Dice.dart';
import '../widgets/QCard.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final GlobalKey<DiceState> diceKey = GlobalKey<DiceState>();

  final Board board = Board();
  OverlayEntry? _overlayEntry;

  int playerNum=0;
  int playerIndex=0;
  bool _isDiceButtonDisabled = false;

  void _getGameRound(value){
    int num = int.tryParse(value) ?? 0;
    setState(() {
      board.setGameRound(num);
    });
  }

  void _getPlayerNumber(value){
    int num = int.tryParse(value) ?? 0;
    setState(() {
      board.setPlayers(num);
    });
  }
  // when roll dice animation ends, add player score
  void _rollDiceButton() async {
    setState(() {
      _isDiceButtonDisabled = true;
    });
    await diceKey.currentState?.rollDice().then((value){
      setState(() {
        board.addPlayerSteps(value);
        board.setCurrentPlayerIndex();
      });
    });

    setState(() {
      _isDiceButtonDisabled = false;
    });
  }

  void _showOverlay(BuildContext context) {
    assert(_overlayEntry == null);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: _hideOverlay,
              child: const Icon(
                Icons.close,
              ),
            ),
            QCard(message: Question().getQuestion(),),
          ],
        );
      },
    );
    // Add the OverlayEntry to the Overlay.
    Overlay.of(context, debugRequiredFor: widget)?.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking'),
      ),
      body: Center(
        child: Wrap(
          children: [
            Column(
              children: [
                Text('Total Steps: ${board.totalStep}',style: Theme.of(context).textTheme.bodyText2),
                // show 'Game Over!' when all player reach the steps
                board.isGameOver()?
                  Text(
                    'Game Over!',
                      style: Theme.of(context).textTheme.headline3
                  )
                : Text(''),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Game Round',
                    ),
                    onFieldSubmitted: _getGameRound,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Player number',
                    ),
                    onFieldSubmitted: _getPlayerNumber,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Dice(key: diceKey,)
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: board.players.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${board.players[index].index}: ${board.players[index].totalStep} steps/${board.players[index].roundNum} round'),
                          // show activate player
                          textColor: board.players[index].isOver ? Colors.black12: Colors.black,
                          selected: board.isCurrentPlayerIndex(index) ? true : false,
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isDiceButtonDisabled ? null : _rollDiceButton,
                  child: const Text('Roll Dice'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showOverlay(context);
                  },
                  child: const Text('Show Q-Card'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
