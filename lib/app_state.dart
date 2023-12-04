import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/GAMEROOM.dart';
import 'models/QUESTION.dart';

class ApplicationState extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  ApplicationState() {
    init();
  }

  String _hostKey = '';

  bool _loggedIn = false;
  bool _isHost = false;

  late GameRoom _currentGame = GameRoom.fromRTDB(id: 'default', data: {});
  late List<Player> _playerList = List.generate(0, (index) => Player.fromRTDB(data: {}));
  Question question = Question();

  bool get loggedIn => _loggedIn;
  bool get isHost => _isHost;
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
    print('====searchGameInfoStream=====');
    print('hostkey: $_hostKey');
    final results = _database.child('games/$_hostKey').onValue;

    final gameStream = results.map((event){
      final gameMap = event.snapshot.value as Map<String, dynamic>;
      _currentGame = GameRoom.fromRTDB(id: _hostKey, data: gameMap);
      _playerList =  (gameMap['players'] as Map<String, dynamic>).entries.map((el){
        String id = el.key.toString();
        final data = el.value as Map<String, dynamic>;
        return Player.fromRTDB(id: id, data: data);
      }).toList();

      _playerList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      _playerList.forEach((element) {print('player: ${element.id} ${element.timestamp.toString()}');});

      print('gameMap: $gameMap');
      print('currentPlayerId : ${_currentGame.currentPlayerId}');

      notifyListeners(); // Notify listeners after processing the data
      return _currentGame;
    });

    return gameStream;
  }

  Future<String> createGame(String code, int num) async{
    print('====createGame=====');
    print('hostkey: $_hostKey');
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    _isHost = true;

    final gameData = {
      'code': code,
      'playerNum': num,
    };
    final newHostKey = _database.child('games').push().key;

    final gameMap = GameRoom.fromRTDB(id: '', data: gameData).toMap();

    print('newHostKey: ${newHostKey.toString()}');
    print('gameMap: $gameMap');
    final Map<String, Map> updates = {};
    updates['/games/$newHostKey'] = gameMap;
    //updates['/game-hosts/$_uid/$newHostKey'];
    print('updates: $updates');

    await _database.update(updates);

    notifyListeners();

    return newHostKey.toString();
  }

  Future<String> createPlayer(String hostKey) async{
    print('====createPlayer=====');
    print('hostkey: $hostKey');
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    _hostKey = hostKey;

    final data = Player.fromRTDB(id:'createPlayer', data:
    {
      'name': FirebaseAuth.instance.currentUser!.displayName.toString(),
    });

    print('player: ${data.toMap()}');
    final Map<String, Map> updates = {};
    updates['/games/$hostKey/players/$_uid'] = data.toMap();

    //set currentGame and players
    await _database.update(updates);

    notifyListeners();

    return _uid;
  }

  Future<void> startGameRoom() async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    _currentGame.currentPlayerId = _uid;

    final updates = {
      '/games/$_hostKey/currentPlayerId': _currentGame.currentPlayerId
    };

    print('====startGameRoom====');
    print('updates: ${updates}');
    await _database.update(updates);

    notifyListeners();
  }

  Future<void> deleteGameRoom() async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    await _database.child('game-hosts/$_uid/$_hostKey').remove();
    await _database.child('games/$_hostKey').remove();

    notifyListeners();
  }

  Future<void> removePlayer() async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    await _database.child('games/$_hostKey/players/$_uid').remove();

    notifyListeners();
  }

  Future<void> setCurrentPlayer() async {
    print('====setCurrentPlayer=====');

    int index = _playerList.indexWhere((element) => element.id == _currentGame.currentPlayerId);

    if(_playerList[index].step <40){
      int next = (index == _playerList.length) ? 0 : index++;
      _currentGame.currentPlayerId = _playerList[next].id;

      print('index: $index, next: $next');
    }

    final updates = {
      '/games/$_hostKey/currentPlayerId': _currentGame.currentPlayerId
    };
    print('currentPlayerId: ${_currentGame.currentPlayerId}');
    await _database.update(updates);

    notifyListeners();
  }

  Future<void> updateDiceValue(int dice) async {
    print('====updateDiceValue=====');
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    print('dice : $dice');
    print('currentPlayerId : ${_currentGame.currentPlayerId}');
    print('uid : ${_uid}');

    // update player step
    Player p = _playerList.firstWhere((element) => element.id == _uid);
    int index = _playerList.indexOf(p);

    int totalStep = _playerList[index].step + dice;

    _playerList[index].step = totalStep;

    if(totalStep >= 40){
      _currentGame.isOver = !_currentGame.isOver;
    }

    final updates = {
      'games/$_hostKey/players/$_uid': _playerList[index].toMap(),
      'games/$_hostKey/isOver': _currentGame.isOver,
    };

    print('updates: $updates');
    await _database.update(updates);
    notifyListeners();
  }

  Future<void> updateQuestion() async {
    print('====updateQuestion=====');
    final msg = question.getRandomQuestion();

    print('question : $msg');
    _currentGame.korean = msg['korean'];
    _currentGame.english = msg['english'];

    final Map<String,dynamic> updates = {
      'games/$_hostKey': _currentGame.toMap()
    };

    print('updates: $updates');
    await _database.update(updates);
    notifyListeners();
  }

  Future<void> updatePlayerReady() async{
    print('====updatePlayerReady=====');
    final String _uid = FirebaseAuth.instance.currentUser!.uid;
    int index = _playerList.indexWhere((element) => element.id == _uid,);

    _playerList[index].isReady = !_playerList[index].isReady;

    Map<String, dynamic> playerMap = Map.fromEntries(
      _playerList.map((player) => MapEntry(player.id, player.toMap())),
    );

    final Map<String, dynamic> updates = {'games/$_hostKey/players': playerMap};
    print('updates: $updates');
    await _database.update(updates);

    notifyListeners();
  }

  bool isTurn(){
    final String _uid = FirebaseAuth.instance.currentUser!.uid;
    if(_uid == _currentGame.currentPlayerId){
      return true;
    }
    return false;
  }
  bool isReady(){
    print('====isReady=====');
    if(!isHost){
      final String _uid = FirebaseAuth.instance.currentUser!.uid;
      Player p = _playerList.firstWhere(
            (element) => element.id == _uid,
        orElse: ()=> Player.fromRTDB(id:'isReady',data:{}),
      );
      print('player: ${p.toMap()}');
      return p.isReady;
    }
    print('isReady function error...');
    return false;
  }
  Player getWinnerPlayer(){
    List<Player> players = _playerList;
    players.sort((a, b) => b.step.compareTo(a.step));
    return players.first;
  }
}