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
          return Row(
            children: [
              AuthFunc(
                  loggedIn: appState.loggedIn,
                  signOut: () {
                    FirebaseAuth.instance.signOut();
                  }
              ),
              // Column(
              //   children: [
              //     Visibility(
              //       visible: appState.loggedIn,
              //       child: Container(
              //         margin: const EdgeInsets.all(8),
              //         width: 200,
              //         child: ElevatedButton(
              //             onPressed: () {
              //               //appState.createGame();
              //               //context.push('/HostGamePage');
              //             },
              //             child: const Text('Host Game')
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
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
                        final games = snapshot.data;
                        games?.forEach((element) {
                          tileList.add(ListTile(
                            title: TextButton(
                              onPressed: () {
                                String hostKey = element.id;
                                appState.createPlayer(hostKey).then((value){
                                  context.go('/waiting-room/$hostKey');
                                });
                              },
                              child: Text('${element.timestamp}')
                            ),
                          ));
                        });
                      }
                      tileList.add(ListTile(
                        title: ElevatedButton(
                            onPressed: () async {
                              appState.createGame().then((value) {
                                print('query value: $value');
                                context.go('/waiting-room/$value');
                              });
                            },
                            child: const Text('Host Game')
                        ),
                      ));
                      return Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children:tileList,
                        ),
                      );
                    }
                ),
              ),
              // Visibility(
              //   visible: appState.loggedIn,
              //   child: Expanded(
              //     child: ListView.separated(
              //       shrinkWrap: true,
              //       padding: const EdgeInsets.all(8),
              //       itemCount: 10,
              //       itemBuilder: (BuildContext context, int index) {
              //         return Text('$index');
              //       },
              //       separatorBuilder: (BuildContext ctx, int idx) {
              //         return Divider();
              //       },
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
