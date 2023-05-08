import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class Player{
  int index=0;
  int score=0;
  int step=0;

  bool isOver=false;

  String name;

  Player({required this.index, this.name='', this.step=0, this.score=0});
}

class Game{
  int playerNum=0;
  int currentPlayerIndex=0; // current player index that is activated
  int round=28;
  int totalStep=28;
  List<Player> players=[];
  String _gameCode='';

  Game({this.round=10, this.playerNum=0,});

  bool isGameOver(){
    return playerNum>0 && players.indexWhere((p) => !p.isOver) == -1;
  }

  void setGameRound(int num){
    totalStep = round * num;
  }

  void generatePlayers(int num){
    playerNum=num;
    currentPlayerIndex=0;
    players = List<Player>.generate(playerNum, (i) => Player(index: i+1));
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
  void addPlayerScore(int diceValue) {
    int index = players.indexWhere((p) => !p.isOver, currentPlayerIndex);
    if(index > -1){
      currentPlayerIndex = index;
      players[currentPlayerIndex].step += diceValue;
      // check player
      if (players[currentPlayerIndex].step >= totalStep) {
        players[currentPlayerIndex].isOver = true;
      }
    }
  }

  bool isCurrentPlayerIndex(int index){
    return index == currentPlayerIndex;
  }

  void generateGameCode() {
    var random = Random.secure();
    var bytes = List<int>.generate(8, (_) => random.nextInt(256));
    var hash = sha256.convert(bytes);
    var code = base64Url.encode(hash.bytes).substring(0, 6);
    _gameCode = code != null ? code:'';
  }

  String getGameCode(){
    return _gameCode;
  }

  int enterGame(String gameCode, String playerName){
    if(getGameCode() == gameCode){
      int index = players.indexWhere((element) => element.name != '');
      if(index == -1){
        players[0].name = playerName;
        return 0;
      }
    }
    return -1;
  }
}