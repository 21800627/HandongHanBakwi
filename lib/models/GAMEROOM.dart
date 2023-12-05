class GameRoom{
  String id = '';
  String code = '';
  bool isOver = false;
  String korean = '';
  String english = '';
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
    required this.korean,
    required this.english,
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
      korean: data['korean'] ?? '',
      english: data['english'] ?? '',
      currentPlayerId: data['currentPlayerId'] ?? '',
      playerNum: data['playerNum'] ?? 1,
      diceValue: data['diceValue'] ?? 0,
      totalStep: data['totalStep'] ?? 0,
      timestamp: (data['timestamp']!=null)
          ? DateTime.fromMicrosecondsSinceEpoch(data['timestamp'])
          : DateTime.now(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'isOver': isOver,
      'korean': korean,
      'english': english,
      'currentPlayerId': currentPlayerId,
      'playerNum': playerNum,
      'diceValue': diceValue,
      'totalStep': totalStep,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}

class Player{
  String id='';
  String name='';
  bool isReady = false;
  bool isHost = false;
  int step = 0;
  DateTime timestamp;

  Player({
    required this.id,
    required this.name,
    required this.isReady,
    required this.isHost,
    required this.step,
    required this.timestamp,
  });

  factory Player.fromRTDB({String id='', required Map<String, dynamic> data, }){
    print("====Player.fromRTDB====");
    print("$data");
    return Player(
      id: id,
      name: data['name'] ?? 'name data not existed..',
      isReady: data['isReady'] ?? false,
      isHost: data['isHost'] ?? false,
      step: data['step'] ?? 0,
      timestamp: (data['timestamp']!=null)
          ? DateTime.fromMicrosecondsSinceEpoch(data['timestamp'])
          : DateTime.now(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isReady': isReady,
      'step': step,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}