import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/models/GAME.dart';

import 'firebase_options.dart';
import 'models/GAMEROOM.dart';
import 'models/QUESTION.dart';

class ApplicationState extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String GAME = 'game';
  String USER = 'user';
  String PLAYER = 'players';

  ApplicationState() {
    init();
  }

  String _hostKey = '';

  bool _loggedIn = false;
  bool _isHost = false;

  late GameRoom _currentGame = GameRoom.fromRTDB(id: 'initial', data: {});
  late List<Player> _playerList = List.generate(0, (index) => Player.fromRTDB(data: {}));
  Question question = Question();

  bool get loggedIn => _loggedIn;
  bool get isHost => _isHost;
  get currentGame => _currentGame;
  get playerList => _playerList;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        if (!user.isAnonymous) {
          _loggedIn = false;
        }
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Stream<List<GameRoom>> getGameListStream(){
    print('====getGameStream=====');
    final streamToPublish = _database.child(GAME).onValue.map((event){
      final gameMap = event.snapshot.value as Map<String, dynamic>;
      final gameList = gameMap.entries.map((el){
        String id = el.key.toString();
        Map<String, dynamic> data = el.value ?? {};
        Map<String, dynamic> playerMap = data[PLAYER] ?? {};
        GameRoom gameRoom = GameRoom.fromRTDB(id: id, data: data);
        print('$data');
        print('playerlength: ${playerMap.entries.length}');
        if(playerMap.length == gameRoom.playerNum){
          return GameRoom.fromRTDB(id: '#waiting_for_start#', data: data);
        }
        return gameRoom;
      }).toList();
      return gameList;
    });
    return streamToPublish;
  }

  Stream<GameRoom> searchGameInfoStream(){
    final String _uid = FirebaseAuth.instance.currentUser!.uid;
    print('====searchGameInfoStream=====');
    print('hostkey: $_hostKey');
    // 2. if game is not over, update currentGame, playerList
    if(!_currentGame.isOver){
      Stream<GameRoom> gameStream = _database.child('$GAME/$_hostKey').onValue.map((event){
        final gameMap = event.snapshot.value as Map<String, dynamic>;
        _currentGame = GameRoom.fromRTDB(id: _hostKey, data: gameMap);
        _playerList =  (gameMap[PLAYER] as Map<String, dynamic>).entries.map((el){
          String id = el.key.toString();
          Map<String, dynamic> data = el.value ?? {};
          return Player.fromRTDB(id: id, data: data);
        }).toList();

        _playerList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        _playerList.forEach((element) {print('player: ${element.id} ${element.timestamp.toString()}');});

        print('gameMap: $gameMap');
        print('currentPlayerId : ${_currentGame.currentPlayerId}');

        return _currentGame;
      });
      return gameStream;
    }
    else{
      // 3. if game is over, update just playerList
      StreamController<GameRoom> controller = StreamController<GameRoom>();
      _database.child('$GAME/$_hostKey/$PLAYER').once().then((event){
        final playerMap = event.snapshot.value as Map<String, dynamic>;
        _playerList =  playerMap.entries.map((el){
          String id = el.key.toString();
          Map<String, dynamic> data = el.value ?? {};
          return Player.fromRTDB(id: id, data: data);
        }).toList();
      });
      controller.add(_currentGame);
      return controller.stream;
    }
  }

  Stream<Player> searchWinnerStream(){
    print('====searchWinnerStream=====');
    print('hostkey: $_hostKey');

    StreamController<Player> controller = StreamController<Player>();
    controller.add(_playerList.firstWhere((element) => element.step>=40, orElse: ()=>Player.fromRTDB(data:{})));
    _playerList.forEach((element) {print('player: ${element.id} ${element.step.toString()}');});

    return controller.stream;
  }

  Future<String> createGame(String code, int num, int time) async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;
    final newHostKey = _database.child(GAME).push().key;
    print('====createGame=====');
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    _hostKey = newHostKey.toString();
    _currentGame = GameRoom.fromRTDB(id: 'createGame', data: {});
    _playerList = List.generate(num, (index) => Player.fromRTDB(data:{}));

    int QNum = time~/num;

    GameRoom gameRoom = GameRoom.fromRTDB(id: '', data: {'code': code, 'playerNum': num, 'QNum': QNum});

    print('newHostKey: ${newHostKey.toString()}');
    print('gameMap: ${gameRoom.toMap()}');

    final Map<String, Map> updates = {};
    updates['/$GAME/$newHostKey'] = gameRoom.toMap();
    print('updates: $updates');

    await _database.update(updates);

    notifyListeners();

    return newHostKey.toString();
  }

  Future<String> createPlayer(String hostKey) async{
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    print('====createPlayer=====');
    print('hostkey: $hostKey');

    //hostkey를 기준으로 다시한번 해보기 4시전에는 최종배포
    final String _uid = FirebaseAuth.instance.currentUser!.uid;
    final pData = Player.fromRTDB(id:'createPlayer', data: {'name': FirebaseAuth.instance.currentUser!.displayName.toString(),});
    Map<String, dynamic> userMap = {};

    if(_hostKey != ''){
      userMap = {
        'hostKey': _hostKey,
        'isHost': true,
        'timestamp': pData.timestamp.microsecondsSinceEpoch,
      };
    }else{
      _hostKey = hostKey;
      userMap = {
        'hostKey': _hostKey,
        'isHost': false,
        'timestamp': pData.timestamp.microsecondsSinceEpoch,
      };

    }

    _isHost = userMap['isHost'];
    print('user: $userMap');

    final Map<String, Map> updates = {
      '/$GAME/$hostKey/$PLAYER/$_uid': pData.toMap(),
      '/$USER/$_uid': userMap
    };

    //set currentGame and players
    try{
      await _database.update(updates);
    }catch(e){
      print(e);
    }

    notifyListeners();

    return _uid;
  }

  Future<void> startGameRoom() async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    _currentGame.currentPlayerId = _uid;

    final updates = {
      '/$GAME/$_hostKey/currentPlayerId': _currentGame.currentPlayerId
    };

    print('====startGameRoom====');
    print('updates: ${updates}');
    try{
      await _database.update(updates);
    }catch(e){
      print(e);
    }

    notifyListeners();
  }

  Future<void> removeGameRoom() async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    await _database.child('$USER/$_uid').remove();
    await _database.child('$GAME/$_hostKey').remove();

    _hostKey = '';
    _playerList = List.generate(0, (index) => Player.fromRTDB(data:{}));

    notifyListeners();
  }

  Future<void> removePlayer() async{
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    await _database.child('$USER/$_uid').remove();
    await _database.child('$GAME/$_hostKey/$PLAYER/$_uid').remove();

    _hostKey = '';
    _playerList = List.generate(0, (index) => Player.fromRTDB(data:{}));

    notifyListeners();
  }

  Future<void> setCurrentPlayer() async {
    print('====setCurrentPlayer=====');

    int index = _playerList.indexWhere((element) => element.id == _currentGame.currentPlayerId);

    if(_playerList[index].step <40){
      int next = 0;
      if(_playerList[index] != _playerList.last){
        next = index+1;
      }
      _currentGame.currentPlayerId = _playerList[next].id;

      print('index: $index, next: $next');
    }

    final updates = {
      '/$GAME/$_hostKey/currentPlayerId': _currentGame.currentPlayerId
    };
    print('currentPlayerId: ${_currentGame.currentPlayerId}');
    try{
      await _database.update(updates);
    }catch(e){
      print(e);
    }

    notifyListeners();
  }

  Future<void> updateDiceValue(int dice) async {
    print('====updateDiceValue=====');
    final String _uid = FirebaseAuth.instance.currentUser!.uid;

    print('dice : $dice');
    print('currentPlayerId : ${_currentGame.currentPlayerId}');
    print('uid : ${_uid}');

    // update player step
    int index = _playerList.indexWhere((element) => element.id == _uid);
    int totalStep = _playerList[index].step + dice;

    _playerList[index].step = totalStep;

    final updates = {
      '$GAME/$_hostKey/$PLAYER/$_uid': _playerList[index].toMap(),
      '$GAME/$_hostKey/isOver': (_playerList[index].step >= 40) ? true: false,
    };

    print('updates: $updates');
    try{
      await _database.update(updates);
    }catch(e){
      print(e);
    }
    notifyListeners();
  }

  Future<bool> updateQuestion() async {
    print('====updateQuestion=====');
    // 1. calculate show Question or not
    int index = _playerList.indexWhere((element) => element.id == _currentGame.currentPlayerId);
    double random = Random().nextDouble();
    double property = (_currentGame.QNum - _playerList[index].answeredQNum)/(40-_playerList[index].step);
    print('random: $random, property: $property');

    bool showQ = (random*property >= 0.5 * property) ? true : false;

    if(!showQ){
      return true;
    }else{
      _playerList[index].answeredQNum++;
      print('name: ${_playerList[index].name}, answeredQNum: ${_playerList[index].answeredQNum}');
    }

    // 2. get Question message
    final msg = question.getRandomQuestion();

    print('question : $msg');
    _currentGame.korean = msg['korean'];
    _currentGame.english = msg['english'];

    final Map<String,dynamic> updates = {
      '$GAME/$_hostKey/korean': _currentGame.korean,
      '$GAME/$_hostKey/english': _currentGame.english,
    };

    print('updates: $updates');
    try{
      await _database.update(updates);
    }catch(e){
      print(e);
    }
    notifyListeners();
    return false;
  }

  Future<void> updatePlayerReady() async{
    print('====updatePlayerReady=====');
    final String _uid = FirebaseAuth.instance.currentUser!.uid;
    int index = _playerList.indexWhere((element) => element.id == _uid,);

    _playerList[index].isReady = !_playerList[index].isReady;

    Map<String, dynamic> playerMap = Map.fromEntries(
      _playerList.map((player) => MapEntry(player.id, player.toMap())),
    );

    final Map<String, dynamic> updates = {'$GAME/$_hostKey/$PLAYER': playerMap};
    print('updates: $updates');
    try{
      await _database.update(updates);
    }catch(e){
      print(e);
    }

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
  Future<void> sendOpinion(String text) async {
    final newOpinion = _database.child('text').push().key;
    final Map<String,dynamic> updates = {'/text/$newOpinion': text};
    print('updates: $updates');
    try{
      await _database.update(updates);
    }catch(e){
      print(e);
    }

  }
}