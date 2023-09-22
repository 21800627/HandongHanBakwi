import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class HostGamePage extends StatefulWidget {
  const HostGamePage({Key? key}) : super(key: key);

  @override
  _HostGamePageState createState() => _HostGamePageState();
}

class _HostGamePageState extends State<HostGamePage> {

  final codeController = TextEditingController();
  final numberController = TextEditingController();

  void _printLatestValue_code() {
    final text = codeController.text;
    print('first text field: $text (${text.characters.length})');
  }
  void _printLatestValue_num() {
    final text = numberController.text;
    print('Second text field: $text (${text.characters.length})');
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    codeController.addListener(_printLatestValue_code);
    numberController.addListener(_printLatestValue_num);
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    codeController.dispose();
    numberController.dispose();
    super.dispose();
  }

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<ApplicationState>(
            builder: (context, appState, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Host Code',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                      controller: codeController,
                      autofocus: true,
                    ),
                  ),
                  Text(
                    'The max number of Players',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                      controller: numberController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: OutlinedButton(
                        onPressed: () {
                          print('${codeController.text}');
                          //appState.setCurrentPlayer(widget.hostKey);
                          var code = codeController.text;
                          var num = int.parse(numberController.text);

                          appState.createGame(code, num).then((hostKey) =>
                            appState.createPlayer(hostKey).then((value) =>
                                context.go('/waiting-room/$hostKey')
                            )
                          );
                        },
                        child: const Text('Confirm')
                    ),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}
