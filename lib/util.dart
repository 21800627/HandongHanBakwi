import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/widgets/QCard.dart';
import 'package:handong_han_bakwi/widgets/CHCard.dart';

import 'models/QUESTION.dart';

void showWarningMessage(context, String title, String message){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

OverlayEntry? _qcard_overlayEntry;
OverlayEntry? _exit_overlayEntry;
OverlayEntry? _chcard_overlayEntry;



void showQCardOverlay(BuildContext context, model) {
  final question = Question();
  assert(_qcard_overlayEntry == null);
  _qcard_overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: hideQCardOverlay,
            child: const Icon(
              Icons.close,
            ),
          ),
          QCard(message: question.Question(),), //getQuestion
        ],
      );
    },
  );
  // Add the OverlayEntry to the Overlay.
  Overlay.of(context)?.insert(_qcard_overlayEntry!);
}


void showCHCardOverlay(BuildContext context, model) {
  final question = Question();
  assert(_chcard_overlayEntry == null);
  _chcard_overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
            onPressed: hideCHCardOverlay,
            child: const Icon(
              Icons.close,
            ),
          ),
          CHCard(message: question.Question(),), //getQuestion()
        ],
      );
    },
  );
  // Add the OverlayEntry to the Overlay.
  Overlay.of(context)?.insert(_chcard_overlayEntry!);
}



// overlay를 리턴해서 페이지내에석  삭제하는 걸로 바꾸기!!
void ShowGameOverOverlay(BuildContext context) {
  assert(_exit_overlayEntry == null);
  _exit_overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: hideGameOverOverlay,
            child: const Icon(
              Icons.close,
            ),
          ),
          Text('Game Over', style: Theme.of(context).textTheme.headline1,)
        ],
      );
    },
  );
  // Add the OverlayEntry to the Overlay.
  Overlay.of(context)?.insert(_exit_overlayEntry!);
}
void hideQCardOverlay() {
  _qcard_overlayEntry?.remove();
  _qcard_overlayEntry = null;
}
void hideGameOverOverlay() {
  _exit_overlayEntry?.remove();
  _exit_overlayEntry = null;
}
void hideCHCardOverlay() {
  _chcard_overlayEntry?.remove();
  _chcard_overlayEntry = null;
}
