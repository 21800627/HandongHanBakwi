class GameRoom{
  String id = '';
  String code = '';

  bool isOver = false;
  String question = '';
  String currentPlayerId = '';
  int playerNum = 0;
  int diceValue = 0;
  int totalStep = 40;
  List<Player> players=[];
  DateTime timestamp;

  //List<List<Player>> tileIndex = List.filled(0,[]);
  //get id => _id;

  GameRoom({
    required this.id,
    required this.code,
    required this.isOver,
    required this.question,
    required this.currentPlayerId,
    required this.playerNum,
    required this.diceValue,
    required this.totalStep,
    //required this.players,
    required this.timestamp,
  });

  factory GameRoom.fromRTDB({required String id, required Map<String, dynamic> data, }){
    return GameRoom(
      id: id,
      code: data['code'] ?? 'code data not existed..',
      isOver: data['isOver'] ?? false,
      question: data['question'] ?? '',
      currentPlayerId: data['currentPlayerId'] ?? '',
      playerNum: data['playerNum'] ?? 1,
      diceValue: data['diceValue'] ?? 0,
      totalStep: data['totalStep'] ?? 0,
      timestamp: DateTime.now(),
      // timestamp: (data['timestamp']!=null)
      //     ? DateTime.fromMicrosecondsSinceEpoch(data['timestamp'])
      //     : DateTime.now(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'isOver': isOver,
      'question': question,
      'currentPlayerId': currentPlayerId,
      'playerNum': playerNum,
      'diceValue': diceValue,
      'totalStep': totalStep,
      'timestamp': timestamp,
    };
  }
  bool isGameOver(){
    return players.isNotEmpty && players.indexWhere((p) => p.step>40) != -1;
  }

  void setDiceValue(int value){
    diceValue = value;
  }

  void setQuestion(String msg){
    question = msg;
  }

  String getQuestion(){
    return question;
  }
}

class Player{
  String id='';
  String name='';
  bool ready = false;
  bool isHost = false;
  bool isOver = false;
  int step = 0;
  DateTime timestamp;

  //get id => _id;
  //get name => _name;

  Player({
    required this.id,
    required this.name,
    required this.ready,
    required this.isHost,
    required this.isOver,
    required this.step,
    required this.timestamp,
  });

  factory Player.fromRTDB({String id='', required Map<String, dynamic> data, }){
    print("====Player.fromRTDB====");
    print("$data");
    return Player(
      id: id,
      name: data['name'] ?? 'name data not existed..',
      ready: data['ready'] ?? false,
      isHost: data['isHost'] ?? false,
      isOver: data['isOver'] ?? false,
      step: data['step'] ?? 0,
      timestamp: (data['timestamp']!=null)
          ? DateTime.fromMicrosecondsSinceEpoch(data['timestamp'])
          : DateTime.now(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ready': ready,
      'isHost': isHost,
      'isOver': isOver,
      'step': step,
      'timestamp': timestamp,
    };
  }
}