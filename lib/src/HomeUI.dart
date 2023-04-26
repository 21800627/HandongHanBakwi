import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/widgets/QCard.dart';
import 'package:handong_han_bakwi/widgets/Dice.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home>{
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    assert(_overlayEntry == null);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: _hideOverlay,
              child: Text('TextButton'),
            ),
            QCard(
              frontWidget: Container(
                width: 500,
                height: 300,
                child: Text('Front of Card'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16),
              ),
              backWidget: Container(
                width: 500,
                height: 300,
                child: Text('Back of Card'),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16),
              ),
            ),
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
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.orange,
              ),
            ),
            width: 250,
            height: 250,
            child: Dice(left: 0.0, top: 0.0)
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _showOverlay(context);
                },
                child: const Text('Show Q-Card'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}