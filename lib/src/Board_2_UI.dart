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

  final Game game = Game(roundStep: 39, roundNum:1, playerNum: 4);
  OverlayEntry? _overlayEntry;

  // when roll dice animation ends, add player score
  void _rollDiceButton() async {
    if(!game.isGameOver()){
      await diceKey.currentState?.rollDice().then((value){
        // _showQCardOverlay(context);
        setState(() {
          game.addPlayerSteps(value);
          game.setCurrentPlayerIndex();
        });
      });
    } else{
      _showExitOverlay(context);
    }
  }

  void _showQCardOverlay(BuildContext context) {
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
  void _showExitOverlay(BuildContext context) {
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
            Text('Game Over', style: Theme.of(context).textTheme.headline1,)
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

  @override
  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    _hideOverlay();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Board'),
        elevation: 0.00,
        automaticallyImplyLeading: false, // hide back button
        backgroundColor: Colors.transparent,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 15.0),
            child: ElevatedButton(
              onPressed: () {
                if(game.isGameOver()){
                  Navigator.pushNamed(context, '/');
                }else{
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Exit'),
                          content: const Text(
                            'Game is not over. Do you really want to exit game?',
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('Exit'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushNamed(context, '/');
                              },
                            ),
                          ],
                        );
                      },
                  );
                }
              },
              child: const Text('Exit'),
            ),
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration:  BoxDecoration (
              color:  Color(0xffe7edf2),
            ),
            width: MediaQuery.of(context).size.width * 0.6,
            child: Center(
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemCount: 40,
                  itemBuilder: (BuildContext context, int index) {
                    r=(index~/8)%2;

                    // if row is odd
                    if(r!=0){
                      // first tile of the row sets j value as 9
                      // j value is decreasing until end of the tile
                      // it calculate viewIndex which shows player moves
                      if(index%8==0){
                        j=7;
                      }
                      else{
                        j=j-2;
                      }
                      viewIndex = index +j;

                      return Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(1),
                        color: Colors.teal[100],
                        child: tileWidget(viewIndex),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(1),
                      color: Colors.teal[100],
                      child: tileWidget(index),
                    );
                  }
              ),
            ),
          ),
          GestureDetector(
            onTap: _rollDiceButton,
            child: Dice(key: diceKey)
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: game.players.length +1,
                    itemBuilder: (context, index) {
                      if(index== game.players.length){
                        return ElevatedButton(
                            onPressed: () {
                              _showQCardOverlay(context);
                            },
                            child: const Text('Show Q-Card'));
                      }
                      return ListTile(
                        // shape: RoundedRectangleBorder(
                        //   side: BorderSide(width: 1),
                        //   borderRadius: BorderRadius.circular(5),
                        // ),
                        dense:true,
                        leading: CircleAvatar(
                          child: FlutterLogo(),
                        ),
                        title: Text(game.showMessageStep(index)),
                        subtitle: Text(game.showMessageRound(index)),
                        // title: Text('${game.players[index].index}: ${game.players[index].totalStep} steps/${game.players[index].roundNum} round'),
                        // show activate player
                        textColor: game.players[index].isOver ? Colors.black12: Colors.black,
                        selected: game.isCurrentPlayerIndex(index) ? true : false,
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  tileWidget(tileIndex) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double parentWidth = constraints.maxWidth;
        double parentHeight = constraints.maxHeight;

        // Calculate the size of the child widget based on the size of the parent widget
        double childWidth = parentWidth * 0.5;
        double childHeight = parentHeight * 0.5;

        List<Widget> playerWidget = [
          Positioned(
              top: 0, // Position each widget vertically
              left: 0, // Position each widget horizontally
              child: Container(
                width: childWidth,
                height: childHeight,
                child: CircleAvatar(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  child: Text('1'),
                ),
              ),
          ),
          // Positioned(
          //     top: 0, // Position each widget vertically
          //     left: 0, // Position each widget horizontally
          //     child: Container(
          //       width: childWidth,
          //       height: childHeight,
          //       color: Colors.yellow,
          //       child: Text('1'),
          //     )
          // ),
          Positioned(
              top: 0, // Position each widget vertically
              right: 0, // Position each widget horizontally
              child: Container(
                width: childWidth,
                height: childHeight,
                color: Colors.redAccent,
                child: Text('2'),
              )
          ),
          Positioned(
              bottom: 0, // Position each widget vertically
              left: 0, // Position each widget horizontally
              child: Container(
                width: childWidth,
                height: childHeight,
                color: Colors.green,
                child: Text('3'),
              )
          ),
          Positioned(
              bottom: 0, // Position each widget vertically
              left: 0, // Position each widget horizontally
              child: Container(
                width: childWidth,
                height: childHeight,
                color: Colors.green,
                child: Text('3'),
              )
          ),
          Positioned(
              bottom: 0, // Position each widget horizontally
              right: 0, // Position each widget vertically
              child: Container(
                width: childWidth,
                height: childHeight,
                color: Colors.blue,
                child: Text('4'),
              )
          )
        ];

        return Stack(
            children: [
              if(tileIndex==0)
                Container(
                  color: Colors.teal[200],
                  child: Center(child: Text('Start')),
                ),
              if(tileIndex==game.roundStep)
                Container(
                  color: Colors.teal[200],
                  child: Center(child: Text('End')),
                ),
              if(tileIndex!=0 && tileIndex!=game.roundStep)
                Center(
                  child: CircleAvatar(
                    minRadius: 10,
                    maxRadius: 20,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    child: Text('$tileIndex', style: const TextStyle(fontSize: 15)),
                  ),
                ),

              //Stack player widget
              for(int i=0; i<4; i++)...[
                if(game.getPlayersByIndex(tileIndex, i))
                  playerWidget[i],
              ]
            ]
        );
      }
  );
}