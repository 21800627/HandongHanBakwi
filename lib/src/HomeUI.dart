import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;

import '../app_state.dart';
import '../auth/authentication.dart';
import '../models/GAMEROOM.dart';

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
          print('appState loggedIn: ${appState.loggedIn}');
          List<GameRoom> games = [];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: !appState.loggedIn,
                child: Container(
                  //Todo: 하진
                  child:Image(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.5,
                      image: AssetImage('assets/images/HBB_LOGO.png')
                  ),
                ),
              ),
              Visibility(
                visible: appState.loggedIn,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 70, 0, 40),
                  child: Text(
                    'Room List',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
              Visibility(
                visible: appState.loggedIn,
                child: StreamBuilder(
                    stream: appState.getGameListStream(),
                    builder: (context, snapshot) {
                      final tileList = <ListTile>[];
                      if(snapshot.hasError){
                        print('getGameStream: ${snapshot.error}');
                        print('getGameStream: ${snapshot.data}');
                      }
                      print('getGameStream: ${snapshot.connectionState}');
                      if(snapshot.hasData){
                        if(snapshot.connectionState == ConnectionState.active){
                          games = snapshot.data!;
                        }
                        int index = 0;
                        games?.forEach((element) {
                          index++;
                          tileList.add(ListTile(
                            title: Center(child: Text('room #$index ${(element.id == '#waiting_for_start#') ? 'waiting for start..' : '${element.code}'}')),
                            selected: (element.id == '#waiting_for_start#') ? true : false,
                              textColor: Colors.deepPurple,
                            selectedColor: Colors.grey,
                            onTap: (){
                              String hostKey = element.id;
                              appState.createPlayer(hostKey).then((value){
                                context.go('/waiting-room');
                              });
                            }
                          ));
                        });
                      }
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0,0,0,40),
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ListView(
                            shrinkWrap: true,
                            children:tileList,
                          ),
                        ),
                      );
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom:30),
                child: Row(
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
              ),
            ],
          );
        },
      ),
    );
  }
}
