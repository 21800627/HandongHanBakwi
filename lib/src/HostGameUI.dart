import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class HostGamePage extends StatelessWidget {

  HostGamePage({Key? key}) : super(key: key);

  final codeController = TextEditingController();
  final numberController = TextEditingController();

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
                          var code = codeController.text;
                          var num = int.parse(numberController.text);

                          appState.createGame(code, num).then((hostKey) =>
                            appState.createPlayer(hostKey).then((value) =>
                                context.go('/waiting-room')
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
