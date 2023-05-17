import 'package:flutter/cupertino.dart';

import 'BOARD.dart';
import 'PLAYER.dart';

class Game extends ChangeNotifier{
  String hostCode = '';

  int roundNum=0;
  List<Player> players=[];

  Board board = Board();

  int diceValue=0;
  String question='';

  void setHostCode(String value){
    hostCode = value;
  }
  void setRoundNum(int value){
    roundNum = value;
  }
  void setPlayerNum(int value){
    players = List.generate(value, (i) => Player(index: i+1));
  }
  void setPlayerName(String value){
    int index = players.indexWhere((p) => p.name == '');
    players[index].name = value;
    notifyListeners();
  }

  void hostGame(){
    board = Board(roundStep: 39, roundNum:roundNum, playerNum: players.length);
    notifyListeners();
  }

  void joinGame(String hostCode){
    if(this.hostCode == hostCode){
      notifyListeners();
    }
  }

  void setDiceValue(int value){
    diceValue = value;
    board.addPlayerSteps(diceValue);
    board.setCurrentPlayerIndex();
    notifyListeners();
  }
}