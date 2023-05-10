import 'package:flutter/material.dart';

import '../models/GAME.dart';
import '../models/QUESTION.dart';
import '../widgets/Dice.dart';
import '../widgets/QCard.dart';

class Board_2_Screen extends StatefulWidget {
  const Board_2_Screen({super.key});

  @override
  State<Board_2_Screen> createState() => _Board_2_ScreenState();
}

class _Board_2_ScreenState extends State<Board_2_Screen>{
  final GlobalKey<DiceState> diceKey = GlobalKey<DiceState>();

  int r=0; //board row
  int j=0; //calculate board tile view index
  int viewIndex=0;

  final Game game = Game(roundStep: 39, playerNum: 3);
  OverlayEntry? _overlayEntry;

  int playerNum=3;
  int playerIndex=0;
  bool _isDiceButtonDisabled = false;

  // when roll dice animation ends, add player score
  void _rollDiceButton() async {
    setState(() {
      _isDiceButtonDisabled = true;
    });
    if(!game.isGameOver()){
      await diceKey.currentState?.rollDice().then((value){
        setState(() {
          game.addPlayerSteps(value);
          game.setCurrentPlayerIndex();
        });
      });
      setState(() {
        _isDiceButtonDisabled = false;
      });
    }
  }
  // roll button 클릭 시 주사위가 overlay 되고 이후에 에니메이션을 주고 싶은데 안됨
  Future<int> _showDiceOverlay(BuildContext context) async{
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
            Dice(key: diceKey),
          ],
        );
      },
    );
    Overlay.of(context, debugRequiredFor: widget)?.insert(_overlayEntry!);
    return 0;
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
        title: Text('Board'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                ),
                itemCount: 40,
                itemBuilder: (BuildContext context, int index) {
                  r=(index~/10)%2;

                  // start Tile
                  if(index==0) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[200],
                      child: Center(child: Text('Start')),
                    );
                  }
                  // if row is odd
                  if(r!=0){
                    // first tile of the row sets j value as 9
                    // j value is decreasing end of the tile
                    // it calculate viewIndex which shows player moves
                    if(index%10==0){
                      j=9;
                    }
                    else{
                      j=j-2;
                    }
                    viewIndex = index +j;

                    // End Tile
                    if(viewIndex==39) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.teal[200],
                        child: Center(child: Text('End')),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[100],
                      child: tile(viewIndex),
                    );
                  }
                  return Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.teal[100],
                    child: tile(index),
                  );
                }
            ),
          ),
          Dice(key: diceKey),
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            child:Column(
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
                          title: Text('${game.players[index].index}: ${game.players[index].totalStep} steps/${game.players[index].roundNum} round'),
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
          )
        ],
      ),
    );
  }

  tile(tileIndex) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double parentWidth = constraints.maxWidth;
        double parentHeight = constraints.maxHeight;

        // Calculate the size of the child widget based on the size of the parent widget
        double childWidth = parentWidth * 0.5;
        double childHeight = parentHeight * 0.5;

        return Stack(
          children: List.generate(playerNum, (index) {
              if(game.board.tileIndex[tileIndex].isNotEmpty) {
                return Positioned(
                  left: 0, // Position each widget horizontally
                  top: 0, // Position each widget vertically
                  child: Container(
                    width: childWidth,
                    height: childHeight,
                    color: Colors.yellow,
                    child: Text('${tileIndex}'),
                  )
                );
              }
              return Container();
              },
          ),
        );
      }
  );
}

class Tile extends StatelessWidget {
   Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;
  final List<Player> players = [];

  @override
  Widget build(BuildContext context) {
    const _defaultColor = Colors.grey;

    final child = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double parentWidth = constraints.maxWidth;
          double parentHeight = constraints.maxHeight;

          // Calculate the size of the child widget based on the size of the parent widget
          double childWidth = parentWidth * 0.5;
          double childHeight = parentHeight * 0.5;

          return Stack(
            children: List.generate(
              players.length,
                  (index) {
                return Positioned(
                  left: 0, // Position each widget horizontally
                  top: 0, // Position each widget vertically
                  child: Container(
                    width: childWidth,
                    height: childHeight,
                    color: Colors.yellow,
                  )
                );
              },
            ),
          );
        }
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}