import 'PLAYER.dart';

class Board {
  int playerNum=0;
  int currentPlayerIndex=0; // current player index that is activated
  int roundStep=39;
  int roundNum=0;
  int totalStep=39;

  List<List<Player>> tileIndex = List.filled(0,[]);

  Board({required this.roundStep, required this.roundNum, required this.playerNum}){
    totalStep = roundStep*roundNum;
    currentPlayerIndex=0;
    // players = List<Player>.generate(playerNum, (i) => Player(index: i+1, roundStep: roundStep, roundNum: roundNum));
    tileIndex = List<List<Player>>.generate(roundStep, (i) => []);
  }

  // 플레이어가 tile위에 있는 지 확인하는 함수
  bool isPlayerOnTileIndex(int index, int playerIndex){
    if(index<roundStep){
      List<Player> playersAtIndex = tileIndex[index];
      return playersAtIndex.any((p) => p.index == playerIndex+1);
    }
    else{
      return false;
    }
  }
  // tile 위에 위치한 플레이어를 지우는 함수
  void removeCurrentPlayerIndex(Player currentPlayerIndex){
    for (var list in tileIndex) {
      if(list.isNotEmpty){
        list.removeWhere((p) => p == currentPlayerIndex);
      }
    }
  }
  // 플레이어를 tile위에 보여주는 함수
  void addCurrentPlayerIndex(Player currentPlayer){
    int currentPlayerStep = 0;
    if(currentPlayer.totalStep < roundStep){
      currentPlayerStep = currentPlayer.totalStep;
    }
    else{
      currentPlayerStep = currentPlayer.totalStep % roundStep;
    }
    tileIndex[currentPlayerStep].add(currentPlayer);
  }

}