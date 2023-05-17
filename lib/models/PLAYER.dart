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