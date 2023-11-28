import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/src/BoardUI.dart';
import 'package:provider/provider.dart';

import '../models/BOARD.dart';
import '../models/GAME.dart';
import '../models/PLAYER.dart';
import '../models/QUESTION.dart';
import '../util.dart';
import '../widgets/Board.dart';
import '../widgets/Dice.dart';
import '../widgets/QCard.dart';


class Board_2_Screen extends StatelessWidget{
  final GlobalKey<DiceState> diceKey = GlobalKey<DiceState>();

  final int roundNum;
  final int roundStep;
  final int playerNum;
  final int _boardCol=8;
  final int _boardTileCount=40;

  bool _isDicePressed = false;


  Board_2_Screen({Key? key, required this.roundNum, required this.roundStep, required this.playerNum})
      : super(key: key);

  void _exitOnPressed(context, model){
    hideQCardOverlay();
    hideGameOverOverlay();
    if(model.isGameOver()){
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
  }
  // when roll dice animation ends, add player score
  void _diceOnPressed(context, model) async {
    if(!model.isGameOver()){
      await diceKey.currentState?.rollDice().then((value){
        model.setQuestion(Question().getRandomQuestion());
        model.setDiceValue(value);

        model.addPlayerSteps(value);
        model.setCurrentPlayerIndex();

        showQCardOverlay(context, model);
      });
    } else{
      //ShowGameOverOverlay(context);
    }
  }
  // Future<int> _rollDice(context,model) async{
  //   if(!model.isGameOver()){
  //     await diceKey.currentState?.rollDice().then((value){
  //       model.setQuestion(Question().getQuestion());
  //       model.setDiceValue(value);
  //
  //       model.addPlayerSteps(value);
  //       model.setCurrentPlayerIndex();
  //
  //       // _qcard_showOverlay(context, model);
  //       return 0;
  //     });
  //   } else{
  //     _exit_showOverlay(context);
  //   }
  //   return -1;
  // }


  @override
  Widget build(BuildContext context) {
    //
    // Game game = Game(playerNum: 4, roundNum: 1);
    final game = Provider.of<Game>(context);
    //
    for (var p in game.players) {
      game.board.addCurrentPlayerIndex(p);
    }

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
              onPressed: ()=>_exitOnPressed(context, game),
              child: const Text('Exit'),
            ),
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Center(
              child: Builder(
                  builder: (context) {
                    int boardRow=0; //board row
                    int j=0; //calculate board tile view index
                    int viewIndex=0;
                    int colorValue=0;

                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _boardCol,
                      ),
                      itemCount: _boardTileCount,
                      itemBuilder: (BuildContext context, int index){

                        boardRow=(index~/_boardCol)%2;

                        if(index==0 || index==_boardTileCount-1) {
                          colorValue = 0xffC4DFDF;
                        } else {
                          colorValue=0xffD2E9E9;
                        }
                        // if row is odd
                        if(boardRow!=0){
                          // first tile of the row sets j value as 9
                          // j value is decreasing until end of the tile
                          // it calculate viewIndex which shows player moves
                          if(index%_boardCol==0){
                            j=_boardCol-1;
                          }
                          else{
                            j=j-2;
                          }
                          viewIndex = index +j;
                        }else{
                          viewIndex=index;
                        }
                        return Card(
                          // padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(3),
                          color: Color(colorValue),
                          elevation: 2,
                          child: _buildTile(game.board, viewIndex),
                        );
                      },
                    );
                  }
              ),
            ),
          ),
          GestureDetector(
              onTap: () => _diceOnPressed(context, game),
              child: Dice(key: diceKey)
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Center(
              child:ListView.builder(
                itemCount: game.players.length +1,
                itemBuilder: (context, index) {
                  if(index== game.players.length){
                    return ElevatedButton(
                        onPressed: () {
                          showQCardOverlay(context, game);
                        },
                        child: const Text('Show Q-Card'));
                  }
                  return ListTile(
                    dense:true,
                    leading: Image.asset(
                      'assets/images/player${index+1}.png',
                    ),
                    title: Text(game.players[index].showTotalStep()),
                    subtitle: Text(game.players[index].showRoundNum()),
                    // show activate player
                    textColor: game.players[index].isOver ? Colors.black12: Colors.black,
                    selected: game.isCurrentPlayerIndex(index) ? true : false,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
  _buildTile(board, tileIndex) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double parentWidth = constraints.maxWidth;
        double parentHeight = constraints.maxHeight;

        // Calculate the size of the child widget based on the size of the parent widget
        double childWidth = parentWidth * 0.55;
        double childHeight = parentHeight * 0.55;

        List<Widget> playerWidget = [
          Positioned(
              top: 0, // Position each widget vertically
              left: 0, // Position each widget horizontally
              child: Image.asset(
                'assets/images/player1.png',
                width: childWidth,
                height: childHeight,
              )
          ),
          Positioned(
              top: 0, // Position each widget vertically
              right: 0, // Position each widget horizontally
              child: Image.asset(
                'assets/images/player2.png',
                width: childWidth,
                height: childHeight,
              )
          ),
          Positioned(
              bottom: 0, // Position each widget vertically
              left: 0, // Position each widget horizontally
              child: Image.asset(
                'assets/images/player3.png',
                width: childWidth,
                height: childHeight,
              )
          ),
          Positioned(
              bottom: 0, // Position each widget horizontally
              right: 0, // Position each widget vertically
              child: Image.asset(
                'assets/images/player4.png',
                width: childWidth,
                height: childHeight,
              )
          )
        ];

        return Stack(
            children: [
              if(tileIndex==0)
                Center(child: Text('Start', style: const TextStyle(fontSize: 15, color: Color(0xffF8F6F4)))),
              if(tileIndex==_boardTileCount-1)
                Center(child: Text('End', style: const TextStyle(fontSize: 15, color: Color(0xffF8F6F4)))),
              if(tileIndex!=0 && tileIndex!=_boardTileCount-1)
                Center(
                  child: Text('$tileIndex', style: const TextStyle(fontSize: 15, color: Color(0xffF8F6F4))),
                ),

              //Stack player widget
              for(int i=0; i<4; i++)...[
                if(board.isPlayerOnTileIndex(tileIndex, i))
                  playerWidget[i],
              ]
            ]
        );
      }
  );
}