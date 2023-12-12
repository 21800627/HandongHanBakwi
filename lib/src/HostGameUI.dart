import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../util.dart';

class HostGamePage extends StatelessWidget {

  HostGamePage({Key? key}) : super(key: key);

  final codeController = TextEditingController();
  final numberController = TextEditingController();
  final timeController = TextEditingController();
  final List<int> timeList = List.generate(6, (i)=> 10*(i+1));

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) {
          return Scaffold(
          appBar: AppBar(
            title: const Text('Host Game'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => exitOnPressed(context, appState),
            ),
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
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
                  Row(
                    children: [
                      Text('Estimated Time: '),
                      DropdownMenu<int>(
                        initialSelection: timeList.first,
                        controller: timeController,
                        label: const Text('minutes'),
                        dropdownMenuEntries: timeList.map<DropdownMenuEntry<int>>((int time) =>
                            DropdownMenuEntry<int>(value: time, label: time.toString())
                        ).toList(),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: OutlinedButton(
                        onPressed: () {
                          var code = codeController.text;
                          var num = int.parse(numberController.text);
                          var time = int.parse(timeController.text);

                          appState.createGame(code, num, time).then((hostKey) =>
                              appState.createPlayer(hostKey).then((value) =>
                                  context.go('/waiting-room')
                              )
                          );
                        },
                        child: const Text('Confirm')
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }
    );
  }
}
