import "dart:math";
import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/widgets/QCard.dart';

final _random = new Random();

List<String> questionList = [
  'What most surprised you when you first arrived on campus or first started classes at this school?',
  'If I visited your hometown, what local spots would you suggest I see?',
  'What movie do you think everyone should watch?',
  'What are three things on your bucket list?',
  'Who is your inspiration?',
  'If you could change one thing about your past, what would it be?',
  'What is your favorites way to spend a weekend?',
  'What is your favorite thing to do on a rainy day?',
  'Who would you choose if you could have a dinner date with anyone in the world?',
];

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
            QCard(message: questionList[_random.nextInt(questionList.length)],),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(5.0),
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
      ),
    );
  }
}
