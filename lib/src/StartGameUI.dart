import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handong_han_bakwi/app_state.dart';
import 'package:provider/provider.dart';

import '../models/QUESTION.dart';
import '../util.dart';
import '../widgets/Dice.dart';

class StartGamePage extends StatelessWidget {

  final GlobalKey<DiceState> diceKey = GlobalKey<DiceState>();

  final String hostKey;
  final int _boardCol=8;
  final int _boardTileCount=40;

  StartGamePage({Key? key, required this.hostKey}) : super(key: key);

  List<Player> players=[];
  List<List<Player>> tileIndex = List.generate(40, (_)=>[]);
  final tileList = <ListTile>[];
  int currentPlayerIndex = 0;
  String currentPlayerId = '';

  void _exitOnPressed(context, model){
    hideQCardOverlay();
    hideGameOverOverlay();
    Navigator.pushNamed(context, '/');
    // if(model.isGameOver()){
    //   Navigator.pushNamed(context, '/');
    // }else{
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Exit'),
    //         content: const Text(
    //           'Game is not over. Do you really want to exit game?',
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             style: TextButton.styleFrom(
    //               textStyle: Theme.of(context).textTheme.labelLarge,
    //             ),
    //             child: const Text('Cancel'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //           TextButton(
    //             style: TextButton.styleFrom(
    //               textStyle: Theme.of(context).textTheme.labelLarge,
    //             ),
    //             child: const Text('Exit'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //               context.push('/');
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }
  // when roll dice animation ends, add player score
  void _diceOnPressed(context, appState) async {
    await diceKey.currentState?.rollDice().then((value) {
      //수정!!
      // 1. set dice value and question
      // 2. update player info
      // 3. get player info
      //_setCurrentPlayerIndex();

      print('currentPlayerId: $currentPlayerId');
      players = appState.updatePlayerInfo(hostKey, value);

      _addPlayerSteps();

      // appState.setDiceValue(value);
      // appState.setQuestion(Question().getQuestion());
      // appState.setPlayerStep(currentPlayerIndex, step);

      //showQCardOverlay(context, appState);
    });
  }

  void _addPlayerSteps() {
    tileIndex = List.generate(40, (_) => []);
    for (var element in players) {
      if(!tileIndex[element.step].contains(element)){
        print(element.step);

        tileIndex[element.step].add(element);
      }
    }
    print(tileIndex);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    print('host key: ${hostKey}');
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
          StreamBuilder(
            stream: appState.searchPlayersInfo(hostKey),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                print('StartGameUI.dart 173: ${snapshot.error}');
              }
              if(snapshot.hasData){
                print('name: ${snapshot.data?.first.name}, step: ${snapshot.data?.first.step}');
                int pindex = 0;
                snapshot.data?.forEach((element) {
                  tileList.add(ListTile(
                    dense:true,
                    leading: Image.asset(
                      'assets/images/player${pindex+1}.png',
                    ),
                    title: Text(element.name),
                    //subtitle: Text('show current steps'),
                    subtitle: Text('${element.step} steps'),
                  ));
                  pindex++;
                });
              }
              return Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Center(
                  child: Builder(
                      builder: (context) {
                        return GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _boardCol,
                          ),
                          itemCount: _boardTileCount,
                          itemBuilder: (BuildContext context, int index){

                            int colorValue=0;

                            if(index==0 || index==_boardTileCount-1) {
                              colorValue = 0xffC4DFDF;
                            } else {
                              colorValue=0xffD2E9E9;
                            }

                            return Card(
                              // padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(3),
                              color: Color(colorValue),
                              elevation: 2,
                              child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    double parentWidth = constraints.maxWidth;
                                    double parentHeight = constraints.maxHeight;

                                    // Calculate the size of the child widget based on the size of the parent widget
                                    double childWidth = parentWidth * 0.55;
                                    double childHeight = parentHeight * 0.55;

                                    int boardRow=0; //board row
                                    int j=0; //calculate board tile view index
                                    int viewIndex=0;

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
                                    print('LayoutBuilder ${snapshot.data?.first.step}: $index, $viewIndex');

                                    return Stack(
                                        children: [
                                          if(viewIndex==0)
                                            const Center(child: Text('Start', style: TextStyle(fontSize: 15, color: Color(0xffF8F6F4)))),
                                          if(viewIndex==_boardTileCount-1)
                                            const Center(child: Text('End', style: TextStyle(fontSize: 15, color: Color(0xffF8F6F4)))),
                                          if(viewIndex!=0 && viewIndex!=_boardTileCount-1)
                                            Center(
                                              child: Text('$viewIndex', style: const TextStyle(fontSize: 15, color: Color(0xffF8F6F4))),
                                            ),

                                          //Stack player widget
                                          if(snapshot.data?.first.step == viewIndex)
                                            playerWidget[0],
                                        ]
                                    );
                                  }
                              ),
                            );
                          },
                        );
                      }
                  ),
                ),
              );
            }
          ),
          GestureDetector(
              onTap: () => _diceOnPressed(context, appState),
              child: Dice(key: diceKey)
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Center(
              child:ListView(
                children:tileList,
              ),
            ),
          )
        ],
      ),
    );
  }
}