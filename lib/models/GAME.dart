import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class Player{
  int index=0;
  int score=0;
  int roundStep=0;
  int roundNum=0;
  int totalStep=0;

  bool isOver=false;

  String name;

  Player({required this.index, this.name='', this.roundStep=0,this.roundNum=1,this.totalStep=0, this.score=0});
}

class Board{
  late List<List<Player>> tileIndex;
}

class Game {
  int playerNum=0;
  int currentPlayerIndex=0; // current player index that is activated
  int roundStep=28;
  int roundNum=0;
  int totalStep=28;

  Board board = Board();
  List<Player> players=[];

  String _gameCode='';

  Game({this.roundStep=10, this.playerNum=0}){
    totalStep = roundStep;
    currentPlayerIndex=0;
    players = List<Player>.generate(playerNum, (i) => Player(index: i+1));
    board.tileIndex = List<List<Player>>.generate(totalStep, (i) => []);
  }

  void setGameRound(int num){
    roundNum=num;
    totalStep = roundStep * num;
    board.tileIndex = List<List<Player>>.generate(totalStep, (i) => []);
  }

  void setPlayers(int num){
    playerNum=num;
    currentPlayerIndex=0;
    players = List<Player>.generate(playerNum, (i) => Player(index: i+1, roundStep: roundStep));
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

  void setGameCode() {
    var random = Random.secure();
    var bytes = List<int>.generate(8, (_) => random.nextInt(256));
    var hash = sha256.convert(bytes);
    var code = base64Url.encode(hash.bytes).substring(0, 6);
    _gameCode = code != null ? code:'';
  }

  String getGameCode(){
    return _gameCode;
  }

  List<Player> getPlayersByIndex(int index){
    List<Player> playersAtIndex = [];
    int currentStep = 0;
    for(int i=0; i<roundNum; i++){
      currentStep = roundNum * index;
      playersAtIndex.addAll(players.where((p) => p.totalStep == currentStep));
    }
    return playersAtIndex;
  }

  bool isGameOver(){
    return playerNum>0 && players.indexWhere((p) => !p.isOver) == -1;
  }

  bool isCurrentPlayerIndex(int index){
    return index == currentPlayerIndex;
  }

  void addPlayerSteps(int diceValue) {
    int index = players.indexWhere((p) => !p.isOver, currentPlayerIndex);

    if(index > -1){
      currentPlayerIndex = index;
      players[currentPlayerIndex].totalStep += diceValue;

      // check player
      if (players[currentPlayerIndex].totalStep >= totalStep) {
        players[currentPlayerIndex].isOver = true;
        players[currentPlayerIndex].roundNum = roundNum;

        for (var list in board.tileIndex) {
          if(list.isNotEmpty){
            list.removeWhere((p) => p == players[currentPlayerIndex]);
          }
        }
        return;
      }

      int currentPlayerStep =  players[currentPlayerIndex].totalStep;
      for (var list in board.tileIndex) {
        if(list.isNotEmpty){
          list.removeWhere((p) => p == players[currentPlayerIndex]);
        }
      }
      board.tileIndex[currentPlayerStep].add(players[currentPlayerIndex]);

      //set round Num
      if(players[currentPlayerIndex].totalStep > roundStep * players[currentPlayerIndex].roundNum){
        players[currentPlayerIndex].roundNum++;
      }
    }
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