
class Player{
  String hostCode='';
  int index=0;
  int score=0;
  int roundStep=0;
  int roundNum=0;
  int totalStep=0;

  bool isOver=false;

  String name;

  Player({required this.index, this.name='', this.roundStep=0,this.roundNum=1,this.totalStep=0, this.score=0, String hostCode=''});

  factory Player.fromRTDB(Map<String, dynamic> data){
    final key = data.keys as int;
    return Player(
      index: key ?? 0,
      hostCode: data[key]['hostCode'] ?? 'Default',
      name: data[key]['name'] ?? 'Default',
      roundStep: data[key]['roundStep'] ?? 0,
      roundNum: data[key]['roundNum'] ?? 0,
      totalStep: data[key]['totalStep'] ?? 0,
      score: data[key]['score'] ?? 0,
    );
  }

  String showTotalStep(){
    return '${totalStep} steps';
  }
  String showRoundNum(){
    return '${roundNum} round';
  }
}