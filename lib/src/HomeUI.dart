import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/models/QUESTION.dart';
import 'package:handong_han_bakwi/widgets/QCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    assert(_overlayEntry == null);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: _hideOverlay,
              child: const Icon(
                Icons.close,
              ),
            ),
            QCard(message: Question().getQuestion(),),
          ],
        );
      },
    );
    // Add the OverlayEntry to the Overlay.
    Overlay.of(context, debugRequiredFor: widget)?.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Text('Handong Han Bakwi',style: Theme.of(context).textTheme.titleLarge),
                    Text('Walk Around with Your Friends',style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/player1.png',
                    width: 50,
                    height: 50,
                  ),
                  Image.asset(
                    'assets/images/player2.png',
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/player3.png',
                    width: 50,
                    height: 50,
                  ),
                  Image.asset(
                    'assets/images/player4.png',
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/board_2_Example');
                  },
                  child: const Text('Start Game'),
                ),
              ),
            ],
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Text('Game Design',style: Theme.of(context).textTheme.titleLarge),
          //     Text('Test Page',style: Theme.of(context).textTheme.bodyLarge),
          //     Container(
          //       margin: const EdgeInsets.only(top: 10.0),
          //       child: ElevatedButton(
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/boardExample');
          //         },
          //         child: const Text('Show Board'),
          //       ),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, '/diceExample');
          //       },
          //       child: const Text('Show Dice'),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         _showOverlay(context);
          //       },
          //       child: const Text('Show Q-Card'),
          //     ),
          //   ],
          // ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Text('Data Flow',style: Theme.of(context).textTheme.titleLarge),
          //     Text('Test Page',style: Theme.of(context).textTheme.bodyLarge),
          //     Container(
          //       margin: const EdgeInsets.only(top: 10.0),
          //       child: ElevatedButton(
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/rankingExample');
          //         },
          //         child: const Text('Player Ranking'),
          //       ),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, '/multiGameExample');
          //       },
          //       child: const Text('Multi Game Player'),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, '/board_2_Example');
          //       },
          //       child: const Text('Board Grid'),
          //     ),
          //   ],
          // ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Container(
          //       margin: const EdgeInsets.all(5.0),
          //       child: ElevatedButton(
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/HostGamePage');
          //         },
          //         child: const Text('Host Game'),
          //       ),
          //     ),
          //     Container(
          //       margin: const EdgeInsets.all(5.0),
          //       child: ElevatedButton(
          //         onPressed: () {
          //           //Navigator.pushNamed(context, '/JoinPage');
          //         },
          //         child: const Text('Join Game'),
          //       ),
          //     ),
          //     Container(
          //       margin: const EdgeInsets.all(5.0),
          //       child: ElevatedButton(
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/WaitingPage');
          //         },
          //         child: const Text('Waiting Game'),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
