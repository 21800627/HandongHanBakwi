import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<String> createGame() async{
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    final gameData = {
      'question': '',
      'diceValue': 0,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    final newHostKey = _database.child('games').push().key;

    final Map<String, Map> updates = {};
    updates['/games/$newHostKey'] = gameData;
    updates['/game-hosts/$_uid/$newHostKey'] = gameData;

    _database.update(updates);

    notifyListeners();

    return newHostKey.toString();
  }

  Future<String> createPlayer(String hostKey) async{
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    final playerData = {
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'isOver': false,
      'step': 0,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    final Map<String, Map> updates = {};
    updates['/games/$hostKey/players/$_uid'] = playerData;

    _database.update(updates);

    notifyListeners();

    return _uid;
  }

  Future<void> setCurrentPlayer(String hostKey) async {
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final results = _database.child('games/$hostKey').get();

    final Map<String, Map> updates = {};

    results.then((snapshot) {
      print('====setCurrentPlayer=====');
      final data = snapshot.value as Map<String, dynamic>;
      final players = data['players'] as Map<String, dynamic>;
      print(data);
      data['currentPlayerId'] = players.keys.first;
      updates['/games/$hostKey'] = data;
      print(updates);
      _database.update(updates);
    });
  }
  List<Player> updatePlayerInfo(String hostKey, int dice){
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final results = _database.child('games/$hostKey').get();

    final Map<String, Map> updates = {};

    int totalStep = 0;
    List<Player> playersList =[];

    print('====updatePlayerInfo=====');
    print('hostKey: $hostKey, diceValue: $dice');

    results.then((snapshot){
      final gameData = snapshot.value as Map<String, dynamic>;
      final players = gameData['players'];
      bool isNext = false;

      players.forEach((key, value){
        String id = key.toString();
        final playerData = value as Map<String, dynamic>;

        if(isNext){
          print('currentPlayerId: ${key.toString()} to ${gameData['currentPlayerId']}');
          gameData['currentPlayerId'] = key.toString();
          gameData['players'] = players;
          return false;
        }
        if(id == gameData['currentPlayerId']){
          totalStep = playerData['step'] + dice;
          playerData['step'] = totalStep;
          isNext = true;
          print('id: $id, data: $playerData');
        }
        players[key] = playerData;
        playersList.add(Player({id: playerData}));
      });
      updates['/games/$hostKey'] = gameData;
      print(updates);

      _database.update(updates);
    });

    //notifyListeners();

    return playersList;
  }

  Stream<List<GameRoom>> getGameStream(){
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final results = _database.child('games').onValue;

    final gameStream = results.map((event){
      final gameMap = event.snapshot.value as Map<String, dynamic>;
      final gameList = gameMap.entries.map((el){
        String id = el.key.toString();
        final data = el.value as Map<String, dynamic>;
        return GameRoom(id, data);
      }).toList();

      return gameList;
    });

    return gameStream;
  }

  Stream<GameRoom> searchGameInfoStream(String hostKey){
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final results = _database.child('games/$hostKey').onValue;

    // print('====searchGameInfoStream=====');
    // print('hostKey: $hostKey');

    final gameStream = results.map((event){
      final gameMap = event.snapshot.value as Map<String, dynamic>;
      // print(gameMap);
      GameRoom gameInfo = GameRoom(hostKey, gameMap);
      return gameInfo;
    });

    return gameStream;
  }
  Stream<List<Player>> searchPlayersInfo(String hostKey){
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final results = _database.child('games/$hostKey/players').get();

    final playersStream = results.asStream().map((event){
      final players = event.value as Map<String, dynamic>;
      List<Player> playersList =[];
      players.forEach((key, value) {
        print('searchvalue: $value');
        playersList.add(Player({key: value}));
      });
      return playersList;
    });

    notifyListeners();
    return playersStream;
  }
}

class GameRoom{
  String _id = '';
  int timestamp = 0;
  List<Player> players=[];
  int diceValue = 0;
  String question = '';
  int totalStep = 40;
  int currentPlayerIndex = 0;

  List<List<Player>> tileIndex = List.filled(0,[]);
  get id => _id;

  GameRoom(String id, Map<String, dynamic> data){
    print("gameroom: $data");
    _id = id;
    timestamp = data['timestamp'];
    if(data.containsKey('players')){
      Player p = Player(data['players']);
      players.add(p);
      //tileIndex[0].add(p);
    }
  }

  bool isGameOver(){
    return players.isNotEmpty && players.indexWhere((p) => p.isOver) != -1;
  }

  void setDiceValue(int value){
    diceValue = value;
  }

  void setQuestion(String msg){
    question = msg;
  }

  String getQuestion(){
    return question;
  }

  void addPlayerSteps(int diceValue) {
    // find current player index
    int index = players.indexWhere((p) => !p.isOver, currentPlayerIndex);
    // if player is not over calculate player total step
    if(index > -1){
      currentPlayerIndex = index;
      // set total step and round Num
      players[currentPlayerIndex].step += diceValue;
      // show on board tile index
      for (var list in tileIndex) {
        if(list.isNotEmpty){
          list.removeWhere((p) => p == currentPlayerIndex);
        }
      }
      if (players[currentPlayerIndex].step >= totalStep) {
        players[currentPlayerIndex].isOver = true;
      }else{
        tileIndex[players[currentPlayerIndex].step].add(players[currentPlayerIndex]);
      }
    }
  }

  void setCurrentPlayerIndex(){
    if(currentPlayerIndex < players.length-1){
      int index = players.indexWhere((p) => !p.isOver, currentPlayerIndex);
      if(index<0){
        int index = players.indexWhere((p) => !p.isOver);
        currentPlayerIndex=index;
      }
      else if (currentPlayerIndex == index){
        int index = players.indexWhere((p) => !p.isOver, currentPlayerIndex+1);
        currentPlayerIndex = index;
      }else{
        currentPlayerIndex=index;
      }
    }else{
      int index = players.indexWhere((p) => !p.isOver);
      currentPlayerIndex = index;
    }
  }

  bool isCurrentPlayerIndex(int index){
    return index == currentPlayerIndex;
  }
}

class Player{
  String _id='';
  String _name='';
  bool isOver = false;
  int step = 0;
  int timestamp = 0;

  get id => _id;
  get name => _name;

  Player(Map<String, dynamic> data){
    print('Player: ${data}');
    print('Player keys: ${data.keys}');
    print('Player values: ${data.values}');
    _id = data.keys.first;
    for(var element in data.values){
      _name = element['name'];
      timestamp = element['timestamp'];
    }
  }
}