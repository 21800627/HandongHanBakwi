import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class RankingPage extends StatelessWidget {

  final String hostKey;

  RankingPage({Key? key, required this.hostKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _){
      return StreamBuilder(
          stream: appState.searchWinnerInfo(hostKey),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              print('RankingPage snapshot.hasError : ${snapshot.error}');
            }
            if(!snapshot.hasData) {
              print('RankingPage: no data');
            }

            final winnerData = snapshot.data ?? Player({'null':'cannotfindwinner'});

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'The Winner is...',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Center(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xff383838),
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              //캐릭터이미지
                              Text('Player Name: ${winnerData.name}'),
                              Text('Player Score: ${winnerData.step}'),
                            ]
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: OutlinedButton(
                          onPressed: () async {
                            if(appState.isHost){
                              appState.deleteGameRoom(hostKey).then((value){
                                Navigator.pushNamed(context, '/');
                                Navigator.pop(context);
                              }
                              );
                            }else{
                              appState.removePlayer(hostKey).then((value){
                                Navigator.pushNamed(context, '/');
                                Navigator.pop(context);
                              }
                              );
                            }
                          },
                          child: const Text('Quit')
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
  });
  }
}
