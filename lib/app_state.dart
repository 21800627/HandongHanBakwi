import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/GAMEROOM.dart';

class ApplicationState extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  ApplicationState() {
    init();
  }

  String _hostKey = '';

  bool _loggedIn = false;
  bool _isHost = false;
  bool _isTurn = true;

  late GameRoom _currentGame = GameRoom.fromRTDB(id: 'default', data: {});
  late List<Player> _playerList = List.generate(0, (index) => Player.fromRTDB(data: {}));

  bool get loggedIn => _loggedIn;
  bool get isHost => _isHost;
  bool get isTurn => _isTurn;
  get playerList => _playerList;

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

  Stream<List<GameRoom>> getGameListStream(){
    print('====getGameStream=====');
    final gameStream = _database.child('games').onValue;

    final streamToPublish = gameStream.map((event){
      final gameMap = event.snapshot.value as Map<String, dynamic>;
      final gameList = gameMap.entries.map((el){
        String id = el.key.toString();
        var data = el.value as Map<String, dynamic>;
        return GameRoom.fromRTDB(id: id, data: data);
      }).toList();
      return gameList;
    });
    return streamToPublish;
  }
  Stream<GameRoom> searchGameInfoStream(){
    final results = _database.child('games/$_hostKey').onValue;

    final gameStream = results.map((event){
      final gameMap = event.snapshot.value as Map<String, dynamic>;
      _currentGame = GameRoom.fromRTDB(id: _hostKey, data: gameMap);
      _playerList =  (gameMap['players'] as Map<String, dynamic>).entries.map((el){
        String id = el.key.toString();
        final data = el.value as Map<String, dynamic>;
        return Player.fromRTDB(id: id, data: data);
      }).toList();

      _playerList.sort((a,b)=>a.timestamp.compareTo(b.timestamp));

      notifyListeners(); // Notify listeners after processing the data
      return _currentGame;
    });

    return gameStream;
  }

  Future<String> createGame(String code, int num) async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    _isHost = true;

    final gameData = {
      'code': code,
      'currentPlayerId': '',
      'playerNum': num,
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
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    _hostKey = hostKey;

    final playerData = {
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'isOver': false,
      'step': 0,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    final Map<String, Map> updates = {};
    updates['/games/$hostKey/players/$_uid'] = playerData;

    //set currentGame and players
    _database.update(updates);

    notifyListeners();

    return _uid;
  }
  Future<void> startGameRoom() async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    _currentGame.currentPlayerId = _uid;

    final Map<String, Map> updates = {};
    updates['/games/$_hostKey'] = _currentGame.toMap();

    print('====startGameRoom====');
    print('${_currentGame.toMap()}');
    _database.update(updates);

    notifyListeners();
  }
  Future<void> deleteGameRoom() async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    _database.child('game-hosts/$_uid/$_hostKey').remove();
    _database.child('games/$_hostKey').remove();

    notifyListeners();
  }

  Future<void> removePlayer() async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    _database.child('games/$_hostKey/players/$_uid').remove();

    notifyListeners();
  }

  Future<void> setCurrentPlayer() async {
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    Player currentPlayer =_playerList.firstWhere((el) => el.id == _currentGame.currentPlayerId);
    int currentPlayerIndex = _playerList.indexOf(currentPlayer);

    if(currentPlayerIndex < _playerList.length-1){
      int index = _playerList.indexWhere((p) => !p.isOver, currentPlayerIndex);
      if(index<0){
        int index = _playerList.indexWhere((p) => !p.isOver);
        currentPlayerIndex=index;
      }
      else if (currentPlayerIndex == index){
        int index = _playerList.indexWhere((p) => !p.isOver, currentPlayerIndex+1);
        currentPlayerIndex = index;
      }else{
        currentPlayerIndex=index;
      }
    }else{
      int index = _playerList.indexWhere((p) => !p.isOver);
      currentPlayerIndex = index;
    }

    final Map<String, Map> updates = {};
    Map<String, dynamic> data = _currentGame.toMap();
    data['currentPlayerId'] = _playerList.elementAt(currentPlayerIndex).id;

    updates['/games/$_hostKey'] = data;
    _database.update(updates);

    if(_currentGame.currentPlayerId == _uid){
      _isTurn = true;
    }else{
      _isTurn = false;
    }

    notifyListeners();
  }

  Future<void> updateDiceValue(int dice) async {
    print('====updateDiceValue=====');
    print('dice : $dice');
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    // 1. update game dice value...?
    _currentGame.diceValue = _currentGame.diceValue + dice;
    // 2. update player step
    if(_uid == _currentGame.currentPlayerId){
      for (var el in _playerList) {
        print('el.id : ${el.id}');
        if(el.id == _uid){
          int totalStep = el.step + dice;
          if(totalStep>=40){
            el.isOver = true;
          }
          el.step = totalStep;
        }
      }
    }
    // Convert _playerList to a map
    Map<String, dynamic> playerMap = Map.fromEntries(
      _playerList.map((player) => MapEntry(player.id, player.toMap())),
    );

    // Create updates map
    final Map<String, dynamic> updates = {'games/$_hostKey/players': playerMap};

    print('updates: $updates');
    _database.update(updates);
    notifyListeners();
  }

  void updatePlayerReady() {
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    // Find the player in _playerList or use a default player if not found
    Player playerToUpdate = _playerList.firstWhere(
          (element) => element.id == _uid,
      orElse: () => Player.fromRTDB(id:'default',data: {}),
    );

    // Toggle the ready status
    playerToUpdate.ready = !playerToUpdate.ready;

    // Convert _playerList to a map
    Map<String, dynamic> playerMap = Map.fromEntries(
      _playerList.map((player) => MapEntry(player.id, player.toMap())),
    );

    // Create updates map
    final Map<String, dynamic> updates = {'games/$_hostKey/players': playerMap};

    // Update the database
    _database.update(updates);

    notifyListeners();
  }
}