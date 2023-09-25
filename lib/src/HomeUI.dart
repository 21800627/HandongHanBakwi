import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;

import '../app_state.dart';
import '../auth/authentication.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _){
          print('appState: ${appState.loggedIn}');
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: appState.loggedIn,
                child: Text(
                  'Room List',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Visibility(
                visible: appState.loggedIn,
                child: StreamBuilder(
                    stream: appState.getGameStream(),
                    builder: (context, snapshot) {
                      final tileList = <ListTile>[];
                      if(snapshot.hasError){
                        print('getGameStream: ${snapshot.error}');
                        print('getGameStream: ${snapshot.data}');
                      }
                      if(snapshot.hasData){
                        print('getGameStream: ${snapshot.connectionState}');
                        int index = 0;
                        final games = snapshot.data;
                        games?.forEach((element) {
                          index++;
                          tileList.add(ListTile(
                            title: TextButton(
                                onPressed: () {
                                  String hostKey = element.id;
                                  appState.createPlayer(hostKey).then((value){
                                    context.go('/waiting-room/$hostKey');
                                  });
                                },
                                child: Text('room #$index ${element.code}')
                            ),
                          ));
                        });
                      }
                      return Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children:tileList,
                        ),
                      );
                    }
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthFunc(
                      loggedIn: appState.loggedIn,
                      signOut: () {
                        FirebaseAuth.instance.signOut();
                      }
                  ),
                  Visibility(
                    visible: appState.loggedIn,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: OutlinedButton(
                          onPressed: () async {
                            // appState.createGame().then((value) {
                            //   print('query value: $value');
                            //   context.go('/waiting-room/$value');
                            // });
                            context.go('/host-game');
                          },
                          child: const Text('Host Game')
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
