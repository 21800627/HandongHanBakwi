import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'PLAYER.dart';

class Board {
  int playerNum=0;
  int currentPlayerIndex=0; // current player index that is activated
  int roundStep=28;
  int roundNum=0;
  int totalStep=28;

  List<List<Player>> tileIndex = List.filled(0,[]);
  List<Player> players=[];

  String _gameCode='';

  Board({this.roundStep=10, this.roundNum=1, this.playerNum=0}){
    totalStep = roundStep*roundNum;
    currentPlayerIndex=0;
    players = List<Player>.generate(playerNum, (i) => Player(index: i+1, roundStep: roundStep, roundNum: roundNum));
    tileIndex = List<List<Player>>.generate(roundStep, (i) => []);
  }

  void setGameRound(int num){
    roundNum=num;
    totalStep = roundStep * num;
    tileIndex = List<List<Player>>.generate(roundStep, (i) => []);
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

  bool getPlayersByIndex(int index, int playerIndex){
    if(index<roundStep){
      List<Player> playersAtIndex = tileIndex[index];
      return playersAtIndex.any((p) => p.index == playerIndex+1);
    }
    else{
      return false;
    }
  }

  bool isGameOver(){
    return playerNum>0 && players.indexWhere((p) => p.isOver) != -1;
  }

  bool isCurrentPlayerIndex(int index){
    return index == currentPlayerIndex;
  }

  void addPlayerSteps(int diceValue) {
    int index = players.indexWhere((p) => !p.isOver, currentPlayerIndex);

    if(index > -1){
      currentPlayerIndex = index;
      players[currentPlayerIndex].totalStep += diceValue;

      //set round Num
      if(players[currentPlayerIndex].totalStep > roundStep * players[currentPlayerIndex].roundNum){
        players[currentPlayerIndex].roundNum++;
      }

      // check player
      if (players[currentPlayerIndex].totalStep >= totalStep) {
        players[currentPlayerIndex].isOver = true;
        players[currentPlayerIndex].roundNum = roundNum;

        for (var list in tileIndex) {
          if(list.isNotEmpty){
            list.removeWhere((p) => p == players[currentPlayerIndex]);
          }
        }
        return;
      }

      int currentPlayerStep = 0;
      if(players[currentPlayerIndex].totalStep < roundStep){
        currentPlayerStep = players[currentPlayerIndex].totalStep;
      }
      else{
        currentPlayerStep = players[currentPlayerIndex].totalStep % roundStep;
      }
      for (var list in tileIndex) {
        if(list.isNotEmpty){
          list.removeWhere((p) => p == players[currentPlayerIndex]);
        }
      }
      tileIndex[currentPlayerStep].add(players[currentPlayerIndex]);
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

  String showMessageStep(int index){
    return '${players[index].totalStep} steps';
  }
  String showMessageRound(int index){
    return '${players[index].roundNum} round';
  }
}