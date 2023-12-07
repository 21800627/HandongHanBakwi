import 'dart:js';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../app_state.dart';

class TutorialPage extends StatelessWidget {

  TutorialPage({Key? key}) : super(key: key);

  MatchEngine _matchEngine= MatchEngine(swipeItems: [SwipeItem(
    content: Card(
      elevation: 2.0,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(25),
            child: Center(
              child: Text(
                "Is there any better idea for korean students to get closer with international students?",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left:25,right:25),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Any ideas about ice-breaking'
              ),
            ),
          ),
          TextButton(
            onPressed: null,
            child: Text('Submit'),
          ),
        ],
      ),
    ),
  )]);

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1,),
              alignment: Alignment.center,
              child: ListView(
                children: [
                  Text(
                    'For the New User',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '1. Press Register button to apply for an account (for the new user)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '2. Verify the email',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '3. Press Profile button to change your user name',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'How to Use Our APP',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '1. Player',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '- Press LOGIN button',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '- Click Room Number to enter the waiting room',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '2. Host',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '- Press LOGIN button',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '- Press HOST GAME button for setting game information',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '- Waiting for players and press Start button to start game',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '3. Click Dice when your turn',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Text(
                    '4. The person who reaches the last board first is the winner!!',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.8 : MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.4,
            padding: EdgeInsets.all(25),
            child: SwipeCards(
                matchEngine: _matchEngine,
                onStackFinished: (){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Thank you for your opinion"),
                    duration: Duration(milliseconds: 500),
                  ));
                },
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 2.0,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(25),
                          child: Center(
                            child: Text(
                              "Is there any better idea for korean students to get closer with international students?",
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left:25,right:25),
                          child: TextFormField(
                            controller: textController,
                            autofocus: true,
                            decoration: InputDecoration(
                                hintText: 'Any ideas about ice-breaking'
                            ),
                          ),
                        ),
                        Consumer<ApplicationState>(
                            builder: (context, appState, _) {
                            return TextButton(
                              onPressed: () async{
                                var text = textController.text;
                                await appState.sendOpinion(text);
                                _matchEngine.currentItem?.superLike();
                              },
                              child: Text('Submit'),
                            );
                          }
                        ),
                      ],
                    ),
                  );
            },
            ),
          )
        ],
      ),
    );
  }
}
