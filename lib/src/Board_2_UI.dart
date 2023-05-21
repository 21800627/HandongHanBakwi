import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/BOARD.dart';
import '../models/GAME.dart';
import '../models/QUESTION.dart';
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
  void _diceOnPressed(context, model, board) async {
    if(!_isDicePressed){
      _isDicePressed = true;
      await _rollDice(context, model, board).then((value){
        if(value>0){
          _isDicePressed = false;
        }
      });
    }
  }
  Future<int> _rollDice(context,model,board) async{
    if(!model.isGameOver()){
      await diceKey.currentState?.rollDice().then((value){
        model.setQuestion(Question().getQuestion());
        model.setDiceValue(value);

        model.addPlayerSteps(value, board);
        model.setCurrentPlayerIndex();

        // _qcard_showOverlay(context, model);
        return 0;
      });
    } else{
      _exit_showOverlay(context);
    }
    return -1;
  }
  // final Board board = Board(roundStep: 39, roundNum:1, playerNum: 4);
  OverlayEntry? _qcard_overlayEntry;
  OverlayEntry? _exit_overlayEntry;

  void _qcard_showOverlay(BuildContext context, model) {
    assert(_qcard_overlayEntry == null);
    _qcard_overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: _qcard_hideOverlay,
              child: const Icon(
                Icons.close,
              ),
            ),
            QCard(message: model.getQuestion(),),
          ],
        );
      },
    );
    // Add the OverlayEntry to the Overlay.
    Overlay.of(context)?.insert(_qcard_overlayEntry!);
  }
  void _exit_showOverlay(BuildContext context) {
    assert(_exit_overlayEntry == null);
    _exit_overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: _exit_hideOverlay,
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
    Overlay.of(context)?.insert(_exit_overlayEntry!);
  }
  void _qcard_hideOverlay() {
    _qcard_overlayEntry?.remove();
    _qcard_overlayEntry = null;
  }
  void _exit_hideOverlay() {
    _exit_overlayEntry?.remove();
    _exit_overlayEntry = null;
  }

  @override
  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    _qcard_hideOverlay();
    _exit_hideOverlay();
  }

  @override
  Widget build(BuildContext context) {

    Game game = Provider.of<Game>(context);
    Board board = Board(roundStep: 39, roundNum: roundNum, playerNum: playerNum);

    for (var p in game.players) {
      board.addCurrentPlayerIndex(p);
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
            // decoration: BoxDecoration (
            //   color:  Color(0xffe7edf2),
            // ),
            width: MediaQuery.of(context).size.width * 0.6,
            child: Center(
              child: _buildBoard(board),
            ),
          ),
          GestureDetector(
              onTap: () => _diceOnPressed(context, game, board),
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
                              _qcard_showOverlay(context, game);
                            },
                            child: const Text('Show Q-Card'));
                      }
                      return ListTile(
                        dense:true,
                        leading: CircleAvatar(
                          child: FlutterLogo(),
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
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildBoard(board) => Builder(
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
              child: _buildTile(board, viewIndex),
            );
          },
        );
      }
  );

  _buildTile(board, tileIndex) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double parentWidth = constraints.maxWidth;
        double parentHeight = constraints.maxHeight;

        // Calculate the size of the child widget based on the size of the parent widget
        double childWidth = parentWidth * 0.5;
        double childHeight = parentHeight * 0.5;

        List<Widget> playerWidget = [
          // Positioned(
          //     top: 0, // Position each widget vertically
          //     left: 0, // Position each widget horizontally
          //     child: Container(
          //       width: childWidth,
          //       height: childHeight,
          //       child: CircleAvatar(
          //         backgroundColor: Colors.yellow,
          //         foregroundColor: Colors.black,
          //         child: Text('1'),
          //       ),
          //     ),
          // ),
          Positioned(
              top: 0, // Position each widget vertically
              left: 0, // Position each widget horizontally
              child: Container(
                width: childWidth,
                height: childHeight,
                color: Color(0xffDBDFAA),
                child: Center(child: Text('1')),
              )
          ),
          Positioned(
              top: 0, // Position each widget vertically
              right: 0, // Position each widget horizontally
              child: Container(
                width: childWidth,
                height: childHeight,
                color: Color(0xffDBDFEA),
                child: Center(child: Text('2')),
              )
          ),
          Positioned(
              bottom: 0, // Position each widget vertically
              left: 0, // Position each widget horizontally
              child: Container(
                width: childWidth,
                height: childHeight,
                color: Color(0xffFAF0D7),
                child: Center(child: Text('3')),
              )
          ),
          Positioned(
              bottom: 0, // Position each widget horizontally
              right: 0, // Position each widget vertically
              child: Container(
                width: childWidth,
                height: childHeight,
                color: Color(0xff8CC0DE),
                child: Center(child: Text('4')),
              )
          )
        ];

        return Stack(
            children: [
              if(tileIndex==0)
                Center(child: Text('Start', style: const TextStyle(fontSize: 15, color: Color(0xffF8F6F4)))),
              if(tileIndex==_boardTileCount)
                Center(child: Text('End', style: const TextStyle(fontSize: 15, color: Color(0xffF8F6F4)))),
              if(tileIndex!=0 && tileIndex!=_boardTileCount)
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