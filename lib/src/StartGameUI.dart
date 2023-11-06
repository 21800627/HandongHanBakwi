import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handong_han_bakwi/app_state.dart';
import 'package:provider/provider.dart';

import '../util.dart';
import '../widgets/Dice.dart';

class StartGamePage extends StatelessWidget {

  final GlobalKey<DiceState> diceKey = GlobalKey<DiceState>();

  final String hostKey;
  final int _boardCol=8;
  final int _boardTileCount=40;

  StartGamePage({Key? key, required this.hostKey}) : super(key: key);

  List<String> imagePaths = List.generate(40, (index) => 'assets/backgrounds/${index + 1}.png');

  void _exitOnPressed(context, appState){
    hideQCardOverlay();
    hideGameOverOverlay();
    if(appState.isGameOver){
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
                  if(appState.isHost){
                    appState.deleteGameRoom(hostKey).then((value){
                      context.push('/');
                      Navigator.pop(context);
                    }
                    );
                  }else{
                    appState.removePlayer(hostKey).then((value){
                      context.push('/');
                      Navigator.pop(context);
                    }
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }
  // when roll dice animation ends, add player score
  void _diceOnPressed(context, appState) async {
    if(!appState.isGameOver && appState.isTurn){
      await diceKey.currentState?.rollDice().then((value) {

        appState.updateDiceValue(hostKey, value);
        //_addPlayerSteps();
        showQCardOverlay(context, appState);

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _){
        return StreamBuilder(
            stream: appState.searchGameInfoStream(hostKey),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                print('StartGameUI.dart 113: ${snapshot.error}');
              }
              if(!snapshot.hasData) {
                print('StartGameUI.dart 116: no data');
              }

              final gameData = snapshot.data ?? GameRoom();
              final players = gameData.players;
              final tileList = <ListTile>[];

              if(gameData.isOver){
                ShowGameOverOverlay(context);
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
                      onPressed: ()=>_exitOnPressed(context, appState),
                      child: const Text('Exit'),
                    ),
                  ),
                ],
              ),
                body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // board tile
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
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
                                  // padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(3),
                                  color: Color(colorValue),
                                  elevation: 2,
                                  child: _buildTile(players, viewIndex),
                                );
                              },
                            );
                          }
                      ),
                    ),
                  ),
                  // dice
                  GestureDetector(
                      onTap: () => _diceOnPressed(context, appState),
                      child: Dice(key: diceKey)
                  ),
                  // player list
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
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
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Color(0xffC4DFDF).withOpacity(0.2),
                    BlendMode.srcATop,
                  ),
                  child: Image.asset(imagePaths[viewIndex]),
                ),
              ),
            //Stack player widget
            for(int i=0; i<players.length; i++)...[
              if(players[i].step == viewIndex)
                playerWidget[i],
            ]
          ],
        );

      }
  );
}