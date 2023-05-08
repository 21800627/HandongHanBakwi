import 'package:flutter/material.dart';

import '../models/GAME.dart';

class MultiGameScreen extends StatefulWidget {
  const MultiGameScreen({super.key});

  @override
  State<MultiGameScreen> createState() => _MultiGameScreenState();
}

class _MultiGameScreenState extends State<MultiGameScreen>{

  final Game game = Game();

  int _gameRound = 0;
  int _playerNumber = 0;
  String _gameCode = '';
  String _playerName = '';

  void _hostGame(){
    setState(() {
      game.setGameRound(_gameRound);
      game.generatePlayers(_playerNumber);
      game.generateGameCode();
    });
  }

  void _joinGame(){
    setState(() {
      game.enterGame(_gameCode, _playerName);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi Game'),
      ),
      body: Center(
        child: Wrap(
          children: [
            Column(
              children: [
                Text('Show Host Code: ${game.getGameCode()}',style: Theme.of(context).textTheme.bodyText2),
                Wrap(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.all(5.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Game Round',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _gameRound = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.all(5.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Player number',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _playerNumber = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: _hostGame,
                    child: const Text('Host Game'),
                  ),
                ),
                Wrap(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.all(5.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter host code',
                        ),
                        onChanged: (value){
                          setState(() {
                            _gameCode = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.all(5.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter player name',
                        ),
                        onChanged: (value){
                          setState(() {
                            _playerName = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: _joinGame,
                    child: const Text('Join Game'),
                  ),
                ),
              ],
            ),
            const VerticalDivider(
              thickness: 2,
              color: Colors.grey,
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: game.players.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('[${game.players[index].index}] ${game.players[index].name}'),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: null,
                    child: const Text('Exit Game [Host]'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5.0),
                  child: ElevatedButton(
                    onPressed: null,
                    child: const Text('Exit Game [Player]'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
