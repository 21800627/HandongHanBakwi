import 'dart:math';
import 'package:flutter/material.dart';

class Player{
  int index=0;
  int score=0;
  int step=0;

  bool isOver=false;

  String name;

  Player({required this.index, this.name='', this.step=0, this.score=0});
}

class Game{
  int playerNum=0;
  int currentPlayerIndex=0; // current player index that is activated
  int round=28;
  int totalStep=28;
  List<Player> players=[];

  Game({this.round=10, this.playerNum=0});

  bool isGameOver(){
    return playerNum>0 && players.indexWhere((p) => !p.isOver, currentPlayerIndex) == -1;
  }

  void setGameRound(int num){
    totalStep = round * num;
  }

  void generatePlayers(int num){
    playerNum=num;
    currentPlayerIndex=0;
    players = List<Player>.generate(playerNum, (i) => Player(index: i+1, name: (i+1).toString()));
  }

  void setCurrentPlayerIndex(){
    if(currentPlayerIndex < playerNum-1){
      currentPlayerIndex++;
    }else{
      currentPlayerIndex=0;
    }
  }
  void addPlayerScore(int diceValue) {
    int index = players.indexWhere((p) => !p.isOver, currentPlayerIndex);
    if(index > -1){
      currentPlayerIndex = index;
      players[currentPlayerIndex].step += diceValue;
      // check player
      if (players[currentPlayerIndex].step >= totalStep) {
        players[currentPlayerIndex].isOver = true;
      }
    }
  }
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
  void _rollDiceButton(){
    diceKey.currentState?._rollDice().then((value){
      setState(() {
        game.addPlayerScore(value);
        game.setCurrentPlayerIndex();
      });
    });
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
                Text('Total Steps: ${game.totalStep}'),
                // show 'Game Over!' when all player reach the steps
                game.isGameOver()?
                  Text(
                    'Game Over!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
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
                RollingDice(key: diceKey,),
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
                          title: Text('${game.players[index].name}: ${game.players[index].step} steps'),
                          // show activate player
                          textColor: game.players[index].isOver ? Colors.black12: Colors.black,
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _rollDiceButton,
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


