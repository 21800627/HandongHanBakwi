import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/models/QUESTION.dart';

import '../models/BOARD.dart';
import '../models/GAME.dart';
import '../widgets/Dice.dart';
import '../widgets/QCard.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  int count = 0;
  String playerLength='';
  String hostCode = '';

  late StreamSubscription _player;
  
  void _performSingleFetch(){
    _ref.get().then((value){
      final data = value as Map<String, dynamic>;
      final game = Game.fromRTDB(data);

      setState(() {
        count= game.playerNum;
        playerLength='player Length: ${game.playerNum}';
      });
    });
  }
  void _activateListeners(){
    _ref.child('players').onValue.listen((event) {
      final data = event.snapshot.value as Map<String, dynamic>;
      final game = Game.fromRTDB(data);

      setState(() {
        playerLength='player Length: ${game.playerNum}';
      });
    });
  }
  @override
  void initState(){
    super.initState();
    // _activateListeners();
  }
  @override
  void deactivate(){
    super.deactivate();
    // _player.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test firebase'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(playerLength),
              ElevatedButton(
                  onPressed: () async{
                    try{
                      await _ref.remove();
                    }catch(e){
                      print('$e');
                      rethrow;
                    }
                  },
                  child: Text('Remove')
              ),
              ElevatedButton(
                  onPressed: () async{
                    try{
                      await _ref.child('players').set({'playerNum':count});
                    }catch(e){
                      print('$e');
                      rethrow;
                    }
                  },
                  child: Text('Set: add player')
              ),
              Container(
                width: 200,
                height: 30,
                margin: EdgeInsets.all(5.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    border: OutlineInputBorder(),
                    labelText: 'Enter Host Code',
                  ),
                  onChanged: (value){
                    setState(() {
                      hostCode = value;
                    });
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () async{
                    try{
                      setState(() {
                        count++;
                      });
                      await _ref.child('players').update({'playerNum':count});
                      await _ref.child('game').push().set({'hostCode': hostCode});
                    }catch(e){
                      print('$e');
                      rethrow;
                    }
                  },
                  child: Text('ADD')
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.5,
            child: StreamBuilder(
              stream: Game().getGameStream(),
              builder: (context, snapshot) {
                final tileList = <ListTile>[];
                if(snapshot.hasData){
                  final games = snapshot.data as List<Game>;
                  tileList.addAll(games.map((nextGame){
                      return ListTile(
                        title: Text('${nextGame.roundNum}'),
                      );
                  }));
                }
                return ListView(
                    children:tileList,
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
