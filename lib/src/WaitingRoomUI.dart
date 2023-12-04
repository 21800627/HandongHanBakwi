import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/GAMEROOM.dart';

class WaitingRoomPage extends StatelessWidget {

  WaitingRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Waiting Room'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if(appState.isHost){
                  appState.deleteGameRoom().then((value) =>
                    Navigator.pop(context)
                  );
                }else{
                  appState.removePlayer().then((value) =>
                      Navigator.pop(context)
                  );
                }
              },
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                  stream: appState.searchGameInfoStream(),
                  builder: (context, snapshot) {
                    final tileList = <ListTile>[];

                    if(snapshot.hasError){
                      print('HostGameUI.dart 41: ${snapshot.error}');
                    }
                    if(snapshot.hasData){
                      List<Player> players = appState.playerList;
                      final int playerNum = snapshot.data?.playerNum ?? 0;

                      if(snapshot.data?.currentPlayerId != ''){
                        context.go('/start-game');
                      }

                      print('player length: ${players.length}, max playernum: ${snapshot.data?.playerNum}');

                      for(int i=0; i<playerNum; i++){
                        if(i==0){
                          tileList.add(
                              ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        child: Text('${players[i].name}',textAlign: TextAlign.center,)
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Icon(
                                        Icons.flag_circle_rounded,
                                        color: Colors.green,
                                        size: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          );
                        }
                        else if(i < players.length) {
                          tileList.add(
                            ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      child: Text('${players[i].name}',textAlign: TextAlign.center,)
                                  ),
                                  players[i].isReady ?
                                  Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                      size: 15.0,
                                    ),
                                  ) :
                                  Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.red,
                                      size: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          );
                        }
                        else{
                          tileList.add(
                              ListTile(
                                selected: true,
                                title: Container(
                                    child: Text('waiting...',textAlign: TextAlign.center,)
                                ),
                              )
                          );
                        }
                      }
                    }
                    return Expanded(
                      child: ListView(
                        children:tileList,
                      ),
                    );
                  }
              ),
              Visibility(
                visible: appState.isHost,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: OutlinedButton(
                      onPressed: () async{
                        appState.startGameRoom();
                      },
                      child: const Text('Start')
                  ),
                ),
              ),
              Visibility(
                visible: !appState.isHost,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: OutlinedButton(
                    onPressed: () async{
                      appState.updatePlayerReady();
                    },
                    child: appState.isReady() ? Text('Not to be played') : Text('Ready'),
                  ),
                ),
              ),
            ],
          )
        );
      }
    );
  }
}
