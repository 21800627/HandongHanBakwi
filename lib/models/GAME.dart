import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'BOARD.dart';
import 'PLAYER.dart';

class Game extends ChangeNotifier{
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  static const GAME_PATH = 'game';
  static const PLAYER_PATH = 'players';

  late StreamSubscription<DatabaseEvent> _gameStream;
  late StreamSubscription<DatabaseEvent> _playerStream;

  String hostCode = '';
  int diceValue=0;
  String question='';

  int currentPlayerNum=0;
  int playerNum=0;
  int currentPlayerIndex=0; // current player index that is activated
  int roundStep=39;
  int roundNum=0;
  int totalStep=39;

  List<Game> _games = [];
  List<Game> get games => _games;

  List<Player> _players = [];
  List<Player> get players => _players;

  Game({this.hostCode='',this.playerNum=0,this.roundNum=0, this.currentPlayerNum=0,}){
    // _listenToGames();
    // _listenToPlayers();
  }

  factory Game.fromRTDB(Map<String, dynamic> data){
    final key = data.keys.first;
    return Game(
      hostCode: key,
      playerNum: data[key]['playerNum'] ?? 0,
      roundNum: data[key]['roundNum'] ?? 0,
      currentPlayerNum: data[key]['currentPlayerNum'] ?? 0,
    );
  }

  @override
  void dispose(){
    _gameStream.cancel();
    _playerStream.cancel();
    super.dispose();
  }

  Stream<List<Player>> getPlayerStream(){
    final results = _database.child('players').onValue;
    final playerStream = results.map((event){
      final playerMap = event.snapshot.value as Map<String, dynamic>;
      final playerList = playerMap.entries.map((el){
        return Player.fromRTDB(el.value as Map<String, dynamic>);
      }).toList();
      return playerList;
    });
    return playerStream;
  }

  Stream<List<Game>> getGameStream(){
    final results = _database.child('game').onValue;
    final gameStream = results.map((event){
      final gameMap = event.snapshot.value as Map<String, dynamic>;
      final gameList = gameMap.entries.map((el){
        return Game.fromRTDB(el.value as Map<String, dynamic>);
      }).toList();
      return gameList;
    });
    return gameStream;
  }
  void _listenToGames(){
    _gameStream = _database.child(GAME_PATH).onValue.listen((event) {
      final allGames = event.snapshot.value as Map<String, dynamic>;
      _games = allGames.values
          .map((data) => Game.fromRTDB(data as Map<String, dynamic>))
          .toList();
    });
  }
  void _listenToPlayers(){
    _playerStream = _database.child(PLAYER_PATH).child(hostCode).onValue.listen((event) {
      final allPlayers = event.snapshot.value as Map<String, dynamic>;
      _players = allPlayers.values
          .map((data) => Player.fromRTDB(data as Map<String, dynamic>))
          .toList();
      notifyListeners();
    });
  }
  bool isGameOver(){
    return playerNum>0 && players.indexWhere((p) => p.isOver) != -1;
  }

  Future<void> hostGame(String hostCode, int roundNum, int playerNum) async{
    currentPlayerIndex=0;
    _database.child(GAME_PATH).update({
      hostCode: {
        'roundNum': roundNum,
        'playerNum': playerNum,
        'totalStep': roundStep * roundNum,
      }
    });
    notifyListeners();
  }

  void joinGame(String joinCode, String playerName) async{
    // get currentPlayerNum
    String? currentIndex='';
    final snapshot = await _database.child(GAME_PATH).child(joinCode).child('currentPlayerNum').get();
    if(snapshot.exists){
      currentIndex = (snapshot.value ?? 0) as String?;
    }
    _database.child(PLAYER_PATH).push().set({
      'hostCode': joinCode,
      'name': playerName,
      'index': currentIndex,
    });
    notifyListeners();
  }

  void setDiceValue(int value){
    diceValue = value;
    notifyListeners();
  }

  void setQuestion(String msg){
    question = msg;
  }

  String getQuestion(){
    return question;
  }

  void addPlayerSteps(int diceValue, Board board) {
    // find current player index
    int index = players.indexWhere((p) => !p.isOver, currentPlayerIndex);
    // if player is not over calculate player total step
    if(index > -1){
      currentPlayerIndex = index;
      // set total step and round Num
      players[currentPlayerIndex].totalStep += diceValue;
      if(players[currentPlayerIndex].totalStep > roundStep * players[currentPlayerIndex].roundNum){
        players[currentPlayerIndex].roundNum++;
      }
      // show on board tile index
      board.removeCurrentPlayerIndex(players[currentPlayerIndex]);
      if (players[currentPlayerIndex].totalStep >= totalStep) {
        players[currentPlayerIndex].isOver = true;
        players[currentPlayerIndex].roundNum = roundNum;
        return;
      }else{
        board.addCurrentPlayerIndex(players[currentPlayerIndex]);
        return;
      }
    }
  }

  void setCurrentPlayerIndex(){
    if(currentPlayerIndex < playerNum-1){
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