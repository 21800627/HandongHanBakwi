
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/GAMEROOM.dart';
import '../util.dart';

class RankingPage extends StatelessWidget {

  RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _){
        return StreamBuilder<Player>(
          stream: appState.searchWinnerStream(),
          builder: (context, snapshot) {
            Player winner = snapshot.data ?? Player.fromRTDB(data: {});
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'The Winner is...',
                      style: Theme.of(context).textTheme.headlineSmall,
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
                                Text('Player Name: ${winner.name}'),
                                Text('Player Score: ${winner.step}'),
                              ]
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: OutlinedButton(
                          onPressed: () async => await exitGameRoom(context, appState),
                          child: const Text('Quit')
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        );
  });
  }
}
