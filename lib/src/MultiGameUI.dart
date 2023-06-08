import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/GAME.dart';
import '../util.dart';

class MultiGameScreen extends StatelessWidget{
  MultiGameScreen({super.key});

  String _hostCode='';
  int _roundNum=0;
  int _playerNum=0;

  String _joinCode='';
  String _playerName='';

  void _hostGameOnPressed(context, model){
    // model.hostGame(_hostCode, _roundNum, _playerNum)
    model.hostGame(_hostCode, 1, 4)
        .then((_){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Operation completed successfully'),
            ),
          );
        }).catchError((error) {
          // Error occurred during the function execution
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
            ),
          );
        });
  }

  void _joinGameOnPressed(context, model){
    model.joinGame(_joinCode, _playerName);
    showWarningMessage(context, 'warning','hello');
  }
  void _enterGameOnPressed(context, model){
    Navigator.pushNamed(
      context,
      '/StartGame',
      arguments: model, // Pass the game object as arguments
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Multi Game'),
          ),
          body: Center(
            child: Wrap(
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        Wrap(
                          children:[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              padding: EdgeInsets.all(5.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Host Code',
                                ),
                                onChanged: (value) {
                                  _hostCode= value;
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              padding: EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: model.hostCode));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Text copied to clipboard')),
                                  );
                                },
                                child: SelectableText(
                                  model.hostCode,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              padding: EdgeInsets.all(5.0),
                              child: TextFormField(
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Game Round',
                                ),
                                onChanged: (value) {
                                  _roundNum = int.tryParse(value) ?? 0;
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              padding: EdgeInsets.all(5.0),
                              child: TextFormField(
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Player number',
                                ),
                                onChanged: (value) {
                                  _playerNum = int.tryParse(value) ?? 0;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: ()=> _hostGameOnPressed(context, model),
                        child: const Text('Host Game'),
                      ),
                    ),
                    Wrap(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(5.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              border: OutlineInputBorder(),
                              labelText: 'Enter host code',
                            ),
                            onChanged: (value) {
                              _joinCode=value;
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(5.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              border: OutlineInputBorder(),
                              labelText: 'Enter player name',
                            ),
                            onChanged: (value) {
                              _playerName= value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: ()=>_joinGameOnPressed(context, model),
                        child: const Text('Join Game'),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Expanded(
                        child: ListView(
                          children: [
                            ...model.games.map((g)=>Card(
                              child: ListTile(
                                  title: Text('${g.hostCode}:')
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: () => _enterGameOnPressed(context, model),
                        child: const Text('Enter Game'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
