import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class WaitingRoomPage extends StatefulWidget {
  const WaitingRoomPage({Key? key, required this.hostKey}) : super(key: key);

  final String hostKey;

  @override
  _WaitingRoomPageState createState() => _WaitingRoomPageState();
}

class _WaitingRoomPageState extends State<WaitingRoomPage> {
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
                  appState.deleteGameRoom(widget.hostKey).then((value) =>
                    Navigator.pop(context)
                  );
                }else{
                  appState.removePlayer(widget.hostKey).then((value) =>
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
                  stream: appState.searchGameInfoStream(widget.hostKey),
                  builder: (context, snapshot) {
                    final tileList = <ListTile>[];

                    if(snapshot.hasError){
                      print('HostGameUI.dart 41: ${snapshot.error}');
                    }
                    if(snapshot.hasData){
                      print('player length: ${snapshot.data?.players.length}, max playernum: ${snapshot.data?.playerNum}');
                      final players = snapshot.data?.players ?? [];
                      final int playerNum = snapshot.data?.playerNum ?? 0;
                      if(snapshot.data?.currentPlayerId != ''){
                        context.go('/start-game/${widget.hostKey}');
                      }
                      for(var p in players){
                        print('player name: ${p.name}');
                      }

                      for(int i=0; i<playerNum; i++){
                        if(i < players.length) {
                          if(players[i].isHost){
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
                          }else{
                            tileList.add(
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          child: Text('${players[i].name}',textAlign: TextAlign.center,)
                                      ),
                                      players[i].ready ?
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
                        }else{
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
                      onPressed: () {
                        appState.setCurrentPlayer(widget.hostKey).then((value) =>
                            context.go('/start-game/${widget.hostKey}')
                        );
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
                    onPressed: () {
                      appState.updatePlayerReady(widget.hostKey);
                    },
                    child: Text(appState.isReady ? 'Not to be played' : 'Ready'),
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
