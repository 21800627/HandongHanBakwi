import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class HostGamePage extends StatefulWidget {
  const HostGamePage({Key? key, required this.hostKey}) : super(key: key);

  final String hostKey;

  @override
  _HostGamePageState createState() => _HostGamePageState();
}

class _HostGamePageState extends State<HostGamePage> {

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Game'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Row(
        children: [
          Consumer<ApplicationState>(
            builder: (context, appState, _) {
              return StreamBuilder(
                  stream: appState.searchGameInfoStream(widget.hostKey),
                  builder: (context, snapshot) {
                    final tileList = <ListTile>[];

                    if(snapshot.hasError){
                      print('HostGameUI.dart 41: ${snapshot.error}');
                    }
                    if(snapshot.hasData){
                      final players = snapshot.data?.players;
                      for (var element in players!) {
                        tileList.add(ListTile(
                          title: Text('${element.name}'),
                        ));
                      }
                    }
                    tileList.add(ListTile(
                      title: ElevatedButton(
                          onPressed: () {
                            //appState.setCurrentPlayer(widget.hostKey);
                             appState.setCurrentPlayer(widget.hostKey).then((value) =>
                               context.go('/start-game/${widget.hostKey}')
                             );
                          },
                          child: const Text('Start Game')
                      ),
                    ));

                    return Expanded(
                      child: ListView(
                        children:tileList,
                      ),
                    );
                  }
              );
            }
          ),
          Column(
            children: [
              Text('${widget.hostKey}'),

            ],
          ),
        ],
      ),
    );
  }
}
