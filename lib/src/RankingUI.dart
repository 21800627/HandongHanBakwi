import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../models/GAME.dart';
import '../widgets/QCard.dart';
final _random = new Random();

List<String> questionList = [
  'What most surprised you when you first arrived on campus or first started classes at this school?',
  'If I visited your hometown, what local spots would you suggest I see?',
  'What movie do you think everyone should watch?',
  'What are three things on your bucket list?',
  'Who is your inspiration?',
  'If you could change one thing about your past, what would it be?',
  'What is your favorites way to spend a weekend?',
  'What is your favorite thing to do on a rainy day?',
  'Who would you choose if you could have a dinner date with anyone in the world?',
];

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final Game game = Game();
  final GlobalKey<_RollingDiceState> diceKey = GlobalKey<_RollingDiceState>();
  OverlayEntry? _overlayEntry;

  List<Player> items = [];
  int playerNum=0;
  int playerIndex=0;
  bool _isDiceButtonDisabled = false;

  void _getGameRound(value){
    int num = int.tryParse(value) ?? 0;
    setState(() {
      game.setGameRound(num);
    });
  }

  void _getPlayerNumber(value){
    int num = int.tryParse(value) ?? 0;
    setState(() {
      game.generatePlayers(num);
    });
  }
  // when roll dice animation ends, add player score
  void _rollDiceButton() async {
    setState(() {
      _isDiceButtonDisabled = true;
    });
    await diceKey.currentState?._rollDice().then((value){
      setState(() {
        game.addPlayerScore(value);
        game.setCurrentPlayerIndex();
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
            QCard(message: questionList[_random.nextInt(questionList.length)],),
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
                Text('Total Steps: ${game.totalStep}',style: Theme.of(context).textTheme.bodyText2),
                // show 'Game Over!' when all player reach the steps
                game.isGameOver()?
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
                  child: RollingDice(key: diceKey,)
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
                      itemCount: game.players.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${game.players[index].index}: ${game.players[index].step} steps'),
                          // show activate player
                          textColor: game.players[index].isOver ? Colors.black12: Colors.black,
                          selected: game.isCurrentPlayerIndex(index) ? true : false,
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isDiceButtonDisabled ? null : _rollDiceButton,
                  // onPressed: _rollDiceButton,
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

class RollingDice extends StatefulWidget {
  const RollingDice({Key? key}) : super(key: key);

  @override
  _RollingDiceState createState() => _RollingDiceState();
}
class _RollingDiceState extends State<RollingDice>
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

  Future<int> _rollDice() async {
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


