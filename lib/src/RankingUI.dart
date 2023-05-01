import 'dart:math';
import 'package:flutter/material.dart';

class Player{
  int index=0;
  int score=0;
  int step=0;

  String name;

  Player({required this.index, this.name='', this.step=0, this.score=0});
}

class Game{
  int playerNum=0;
  int round=0;
  int totalStep=28;

  Game({this.round=0, this.playerNum=0, this.totalStep=28});
}

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final Game game = Game();
  final GlobalKey<_RollingDiceState> diceKey = GlobalKey<_RollingDiceState>();
  List<Player> items = [];
  int playerNum=0;
  int playerIndex=0;

  void _generatePlayer(int num) {
    setState(() {
      playerNum=num;
      // game.playerNum = num;
      playerIndex=0;
      items = List<Player>.generate(num, (i) => Player(index: i+1, name: (i+1).toString()));
    });
  }

  void _addPlayerScore() {
    diceKey.currentState?._rollDice();
    setState(() {
      items[playerIndex].step += diceKey.currentState!._diceValue;

      if (playerIndex < playerNum-1){
        playerIndex++;
      }else{
        playerIndex=0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking'),
      ),
      body: Center(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Game Round',
                    ),
                    onFieldSubmitted: (value) {
                      int num = int.tryParse(value) ?? 0;
                      //_generatePlayer(num);
                      game.round = num;
                      game.totalStep *= num;
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Player number',
                    ),
                    onFieldSubmitted: (value) {
                      int num = int.tryParse(value) ?? 0;
                      _generatePlayer(num);
                    },
                  ),
                ),
                RollingDice(key: diceKey,)
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
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${items[index].name}: ${items[index].step} steps'),
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addPlayerScore,
                  child: const Text('Roll Dice'),
                ),
                ElevatedButton(
                  onPressed: () {
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

  late final Animation<double> _scale = Tween<double>(
    begin: 1,
    end: 1,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutBack,
  ));

  int _diceValue = 1;
  double _imageSize = 50;

  void _rollDice() {
    setState(() {
      _diceValue = Random().nextInt(6) + 1;
      _imageSize = 100; // Reset the image size before starting the animation
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotation,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (context, child) {
            if (_scale.isCompleted) {
              _imageSize = 50; // Set the image size based on the scale animation value
            }
            return Image.asset(
              'assets/images/dice$_diceValue.png',
              height: _imageSize,
              width: _imageSize,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


