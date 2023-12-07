import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handong_han_bakwi/app_state.dart';
import 'package:handong_han_bakwi/models/GAME.dart';
import 'package:provider/provider.dart';

import '../models/GAMEROOM.dart';
import '../util.dart';
import '../widgets/Dice.dart';

class StartGamePage extends StatelessWidget {

  final GlobalKey<DiceState> diceKey = GlobalKey<DiceState>();

  final int _boardCol=8;
  final int _boardTileCount=40;

  String question = '';

  StartGamePage({Key? key}) : super(key: key);

  List<String> imagePaths = List.generate(40, (index) => 'assets/backgrounds/${index + 1}.png');

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _){
          return StreamBuilder(
            stream: appState.searchGameInfoStream(),
            builder: (context,snapshot) {
              GameRoom gameData = snapshot.data ?? GameRoom.fromRTDB(id: 'default', data: {});
              List<Player> players = appState.playerList;
              final tileList = <ListTile>[];
              print('gameData.isOver: ${gameData.isOver}');
              if(gameData.id == 'default' || gameData.isOver){
                hideQCardOverlay();
                context.pushNamed('/ranking');
              }
              print('gameData.korean: $question, currentGame.korean: ${gameData.korean}');
              if(question == gameData.korean){
                question = gameData.korean;
              }
              if(question != gameData.korean){
                showQCardOverlay(context, gameData.korean, gameData.english);
                question = gameData.korean;
              }
              for (int i=0; i<players.length; i++) {
                tileList.add(ListTile(
                  dense:true,
                  leading: Image.asset(
                    'assets/images/player${i+1}.png',
                  ),
                  title: Text(players[i].name),
                  //subtitle: Text('show current steps'),
                  subtitle: Text('${players[i].step} steps'),
                  selected: (players[i].id != gameData.currentPlayerId) ? false: true,
                  selectedColor: Colors.amber,
                ));
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
                        onPressed: () => exitOnPressed(context, appState),
                        child: const Text('Exit'),
                      ),
                    ),
                  ],
                ),
                body: MediaQuery.of(context).orientation == Orientation.portrait
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // board tile
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Builder(
                            builder: (context) {
                              int colorValue=0;
                              int boardRow=0; //board row
                              int j=0; //calculate board tile view index
                              int viewIndex=0;

                              return GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _boardCol,
                                ),
                                itemCount: _boardTileCount,
                                itemBuilder: (BuildContext context, int index){

                                  if(index==0 || index==_boardTileCount-1) {
                                    colorValue = 0xffC4DFDF;
                                  } else {
                                    colorValue=0xffD2E9E9;
                                  }

                                  boardRow=(index~/_boardCol)%2;

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
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(width: 2.0, color: Color(0xff383838)),
                                    ),
                                    // padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(3),
                                    //color: Color(colorValue),
                                    //elevation: 2,
                                    child: _buildTile(players, viewIndex),
                                  );
                                },
                              );
                            }
                        ),
                      ),
                    ),
                    // dice
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: ()async{
                            if(appState.isTurn()){
                              await diceKey.currentState?.rollDice().then((value) {

                                // appState.updateDiceValue(value);
                                appState.updateDiceValue(value).then((value) =>
                                    appState.setCurrentPlayer().then((value) =>
                                        appState.updateQuestion()
                                    )
                                );
                                //_addPlayerSteps();
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Dice(key: diceKey),
                          )
                      ),
                    ),
                    // player list
                    Expanded(
                      flex: 1,
                      child: Center(
                        child:ListView(
                          children:tileList,
                        ),
                      ),
                    ),
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // board tile
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Builder(
                            builder: (context) {
                              int colorValue=0;
                              int boardRow=0; //board row
                              int j=0; //calculate board tile view index
                              int viewIndex=0;

                              return GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _boardCol,
                                ),
                                itemCount: _boardTileCount,
                                itemBuilder: (BuildContext context, int index){

                                  if(index==0 || index==_boardTileCount-1) {
                                    colorValue = 0xffC4DFDF;
                                  } else {
                                    colorValue=0xffD2E9E9;
                                  }

                                  boardRow=(index~/_boardCol)%2;

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
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(width: 2.0, color: Color(0xff383838)),
                                    ),
                                    // padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(3),
                                    //color: Color(colorValue),
                                    //elevation: 2,
                                    child: _buildTile(players, viewIndex),
                                  );
                                },
                              );
                            }
                        ),
                      ),
                    ),
                    // dice
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: ()async{
                            if(appState.isTurn()){
                              await diceKey.currentState?.rollDice().then((value) {

                                // appState.updateDiceValue(value);
                                appState.updateDiceValue(value).then((value) =>
                                    appState.setCurrentPlayer().then((value) =>
                                        appState.updateQuestion()
                                    )
                                );
                                //_addPlayerSteps();
                              });
                            }
                          },
                          child: Dice(key: diceKey)
                      ),
                    ),
                    // player list
                    Expanded(
                      flex: 1,
                      child: Center(
                        child:ListView(
                          children:tileList,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          );
      }
    );
  }
  _buildTile(players, viewIndex) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        List<bool> _visible = List.generate(_boardTileCount, (index) => true);
        List<List<bool>> _playersVisible = List.generate(players.length, (index) => _visible);
        for(int i=0; i<players.length; i++){
          bool _isOdd = (viewIndex%2==0);
          if(players[i].step < viewIndex){
            if(_isOdd){
              _playersVisible[i][viewIndex] = false;
            }else{
              _playersVisible[i][viewIndex] = true;
            }
          }
        }

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
            // Display start image
            if (viewIndex == 0)
              Center(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Color(0xffC4DFDF).withOpacity(0.2),
                    BlendMode.srcATop,
                  ),
                  child: Image.asset(imagePaths[0]),
                ),
              ),

            // Display end image
            if (viewIndex == _boardTileCount - 1)
              Center(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Color(0xffC4DFDF).withOpacity(0.2),
                    BlendMode.srcATop,
                  ),
                  child: Image.asset(imagePaths[_boardTileCount - 1]),
                ),
              ),

            // Display other images
            if (viewIndex != 0 && viewIndex != _boardTileCount - 1)
              Center(
                child: Image.asset(imagePaths[viewIndex]),
              ),
            //Stack player widget
            for(int i=0; i<players.length; i++)...[
              if(players[i].step == viewIndex)
                playerWidget[i],
                // AnimatedOpacity(
                //   // If the widget is visible, animate to 0.0 (invisible).
                //   // If the widget is hidden, animate to 1.0 (fully visible).
                //   opacity: _playersVisible[i][viewIndex] ? 1.0 : 0.0,
                //   duration: const Duration(milliseconds: 500),
                //   // The green box must be a child of the AnimatedOpacity widget.
                //   child: playerWidget[i],
                // )
            ]
          ],
        );
      }
  );
}