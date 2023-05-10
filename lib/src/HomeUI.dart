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
            children: <Widget>[
              Text('Game Design',style: Theme.of(context).textTheme.headline6),
              Text('Test Page',style: Theme.of(context).textTheme.bodyLarge),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/boardExample');
                  },
                  child: const Text('Show Board'),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/diceExample');
                  },
                  child: const Text('Show Dice'),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: () {
                    _showOverlay(context);
                  },
                  child: const Text('Show Q-Card'),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/board_2_Example');
                  },
                  child: const Text('Board Grid'),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Data Flow',style: Theme.of(context).textTheme.headline6),
              Text('Test Page',style: Theme.of(context).textTheme.bodyLarge),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/rankingExample');
                  },
                  child: const Text('Player Ranking'),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/multiGameExample');
                  },
                  child: const Text('Multi Game Player'),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/HostGamePage');
                  },
                  child: const Text('Host Game'),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: () {
                    //Navigator.pushNamed(context, '/JoinPage');
                  },
                  child: const Text('Join Game'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
