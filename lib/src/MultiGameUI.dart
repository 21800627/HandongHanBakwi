import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/GAME.dart';

class MultiGameScreen extends StatelessWidget{
  const MultiGameScreen({super.key});

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
                                  model.setHostCode(value);
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
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),                            ),
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
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Game Round',
                                ),
                                onChanged: (value) {
                                  model.setRoundNum(int.parse(value));
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              padding: EdgeInsets.all(5.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Player number',
                                ),
                                onChanged: (value) {
                                  model.setPlayerNum(int.parse(value));
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
                        onPressed: (){
                          model.hostGame();
                        },
                        child: const Text('Host Game'),
                      ),
                    ),
                    Wrap(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(5.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              border: OutlineInputBorder(),
                              labelText: 'Enter host code',
                            ),
                            onChanged: (value) {
                              model.hostGame();
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(5.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              border: OutlineInputBorder(),
                              labelText: 'Enter player name',
                            ),
                            onChanged: (value) {
                              model.setPlayerName(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: (){},
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
                            ...model.players.map((p)=>Card(
                              child: ListTile(
                                  title: Text('${p.index}:')
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/board_2_Example');
                        },
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
