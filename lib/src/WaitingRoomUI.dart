import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class WaitingRoomPage extends StatefulWidget {
  const WaitingRoomPage({Key? key, required this.hostKey}) : super(key: key);

  final String hostKey;

  @override
  _WaitingRoomPageState createState() => _WaitingRoomPageState();
}

class _WaitingRoomPageState extends State<WaitingRoomPage> {

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting Room'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ApplicationState>(
          builder: (context, appState, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
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
                          title: Container(
                              child: Text('${element.name}',textAlign: TextAlign.center,)
                          ),
                        ));
                      }
                    }
                    return Expanded(
                      child: ListView(
                        children:tileList,
                      ),
                    );
                  }
              ),
              Container(
                margin: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.25,
                child: OutlinedButton(
                    onPressed: () {
                      appState.setCurrentPlayer(widget.hostKey).then((value) =>
                        context.go('/start-game/${widget.hostKey}')
                      );
                    },
                    child: const Text('Start')
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
