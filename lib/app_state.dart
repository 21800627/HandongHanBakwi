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
  bool _isReady = false;
  bool _isHost = false;
  bool get loggedIn => _loggedIn;
  bool get isReady => _isReady;
  bool get isHost => _isHost;

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

  Future<String> createGame(String code, int num) async{
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    print('====createGame=====');
    print('code: $code, number: $num');
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    _isHost = true;

    final gameData = {
      'code': code,
      'playerNum': num,
      'question': '',
      'diceValue': 0,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    final newHostKey = _database.child('games').push().key;

    final Map<String, Map> updates = {};
    updates['/games/$newHostKey'] = gameData;
    updates['/game-hosts/$_uid/$newHostKey'] = gameData;

    //print(updates);
    _database.update(updates);

    notifyListeners();

    return newHostKey.toString();
  }

  Future<String> createPlayer(String hostKey) async{
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    print('====createPlayer=====');
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

  Future<void> removePlayer(String hostKey) async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;
    final DatabaseReference _database = FirebaseDatabase.instance.ref();

    if(_isHost){
      _database.child('game-hosts/$_uid').remove();
      _database.child('games/$hostKey').remove();
    }
    else{
      _database.child('games/$hostKey/players/$_uid').remove();
    }

    notifyListeners();
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
  Future<void> updateDiceValue(String hostKey, int dice) async {
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final results = _database.child('games/$hostKey').get();

    final Map<String, Map> updates = {};

    int totalStep = 0;

    print('====updateDiceValue=====');
    print('hostKey: $hostKey, diceValue: $dice');

    results.then((snapshot) {
      final gameData = snapshot.value as Map<String, dynamic>;
      var diceValue = gameData['diceValue'] as int;
      final players = gameData['players'] as Map<String, dynamic>;

      var sum = diceValue + dice;

      bool isNext = false;

      print('gameData: $gameData');
      players.forEach((key, value){
        String id = key.toString();
        final playerData = value as Map<String, dynamic>;

        if(isNext){
          print('currentPlayerId: ${key.toString()} to ${gameData['currentPlayerId']}');
          if(players.keys.last == gameData['currentPlayerId']){
            gameData['currentPlayerId'] = players.keys.first;
          }else{
            gameData['currentPlayerId'] = key.toString();
          }
          gameData['players'] = players;
          return;
        }
        if(id == gameData['currentPlayerId']){
          print('dice: $dice, step: ${playerData['step']}');
          totalStep = playerData['step'] + dice;
          print('totalStep: $totalStep, dice: $dice, step: ${playerData['step']}');
          playerData['step'] = totalStep;
          isNext = true;
          print('id: $id, data: $playerData');
        }
        players[key] = playerData;
      });

      gameData['diceValue'] = sum;
      updates['/games/$hostKey'] = gameData;
      print(updates);

      _database.update(updates);
    });
  }
  void updatePlayerInfo(String hostKey){
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final results = _database.child('games/$hostKey').get();

    final Map<String, Map> updates = {};

    int totalStep = 0;
    List<Player> playersList =[];

    print('====updatePlayerInfo=====');
    print('hostKey: $hostKey');

    results.then((snapshot){
      final gameData = snapshot.value as Map<String, dynamic>;
      final players = gameData['players'];
      final dice = gameData['diceValue'];
      bool isNext = false;

      print('gameData: $gameData');
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
          print('dice: $dice, step: ${playerData['step']}');
          totalStep = playerData['step'] + dice;
          print('totalStep: $totalStep, dice: $dice, step: ${playerData['step']}');
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

    notifyListeners();
  }
  void updatePlayerReady(String hostKey){
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final String _uid = FirebaseAuth.instance.currentUser!.uid;
    final results = _database.child('games/$hostKey/players/$_uid').get();

    final Map<String, Map> updates = {};

    print('====updatePlayerReady=====');

    results.then((snapshot){
      final playerData = snapshot.value as Map<String, dynamic>;
      print(playerData);
      //playerData['ready'] = !ready;
      _isReady = !_isReady;
      playerData['ready'] = _isReady;

      updates['games/$hostKey/players/$_uid'] = playerData;

      _database.update(updates);
    });

    notifyListeners();
  }

  Stream<List<GameRoom>> getGameStream(){
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final results = _database.child('games').onValue;

    print('====getGameStream=====');
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

    print('====searchGameInfoStream=====');
    print('hostKey: $hostKey');

    final gameStream = results.map((event){
      final gameMap = event.snapshot.value as Map<String, dynamic>;
      print('gameMap: $gameMap');
      GameRoom gameInfo = GameRoom(hostKey, gameMap);
      return gameInfo;
    });

    return gameStream;
  }
  Stream<List<Player>> searchPlayersInfo(String hostKey){
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    final results = _database.child('games/$hostKey/players').onValue;

    print('====searchPlayersInfo=====');
    print('hostKey: $hostKey');
    final playersStream = results.map((event){
      final players = event.snapshot.value as Map<String, dynamic>;
      List<Player> playersList =[];
      players.forEach((key, value) {
        print('searchvalue: $value');
        playersList.add(Player({key: value}));
      });
      for (var value1 in playersList) {
        print('playerLIst name: ${value1.name}, step: ${value1.step}');
      }
      return playersList;
    });

    notifyListeners();
    return playersStream;
  }
}

class GameRoom{
  String _id = '';
  String code = '';
  int playerNum = 0;
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
    code = data['code'];
    playerNum = data['playerNum'];
    timestamp = data['timestamp'];
    if(data.containsKey('players')){
      var ps = data['players'] as Map<String, dynamic>;
      for(var p in ps.entries){
        Player player = Player({p.key: p.value});
        players.add(player);
      }
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
  bool ready = false;
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
      step = element['step'];
      timestamp = element['timestamp'];
      ready = element['ready'] ?? false;
    }
  }
}