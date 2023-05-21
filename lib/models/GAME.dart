import 'package:flutter/cupertino.dart';

import 'BOARD.dart';
import 'PLAYER.dart';

class Game extends ChangeNotifier{
  String hostCode = '';
  int diceValue=0;
  String question='';

  int playerNum=0;
  int currentPlayerIndex=0; // current player index that is activated
  int roundStep=39;
  int roundNum=0;
  int totalStep=39;

  List<Player> _players = [];
  List<Player> get players => _players;

  bool isGameOver(){
    return playerNum>0 && players.indexWhere((p) => p.isOver) != -1;
  }

  void hostGame(String hostCode, int roundNum, int playerNum){
    //TODO: check host code
    this.hostCode = hostCode;
    this.roundNum = roundNum;
    this.playerNum = playerNum;

    totalStep = roundStep*this.roundNum;
    currentPlayerIndex=0;

    _players = List<Player>.generate(playerNum, (i) => Player(index: i+1, roundStep: roundStep, roundNum: roundNum));

    notifyListeners();
  }

  void joinGame(String joinCode, String playerName){
    //TODO: check join code
    // if(hostCode == joinCode){
    //   int index = board.players.indexWhere((p)=> p.name == '');
    //   board.players[index].name = playerName;
    // }
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