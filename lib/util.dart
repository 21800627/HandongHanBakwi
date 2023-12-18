import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handong_han_bakwi/widgets/QCard.dart';
import 'package:handong_han_bakwi/widgets/CHCard.dart';

import 'models/CHCQUESTION.dart';
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

OverlayEntry? _exit_overlayEntry;
OverlayEntry? chanceOverlayEntry;
OverlayEntry? qCardOverlayEntry;

OverlayEntry _qCardBuilder(String korean, String english) {
  return OverlayEntry(
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: hideQCardOverlay,
            child: const Icon(
              Icons.close,
            ),
          ),
          QCard(
            koreanMessage: korean,
            englishMessage: english,
          ),
        ],
      );
    },
  );
}

void showQCardOverlay(BuildContext context, String korean, String english) {
  Future.delayed(Duration.zero,() =>
    qCardOverlayEntry = _qCardBuilder(korean, english)
  ).then((value) =>
      Overlay.of(context).insert(qCardOverlayEntry!)
  );
}


void showCHCardOverlay(BuildContext context, model) {
  final chcq = CHCQuestion();
  assert(chanceOverlayEntry == null);
  chanceOverlayEntry = OverlayEntry(
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
          CHCard(message: chcq.getRandomCHC(),),
        ],
      );
    },
  );
  // Add the OverlayEntry to the Overlay.
  Overlay.of(context).insert(chanceOverlayEntry!);
}

void hideCHCardOverlay() {
  chanceOverlayEntry?.remove();
  chanceOverlayEntry = null;
}



// overlay를 리턴해서 페이지내에석  삭제하는 걸로 바꾸기!!
void ShowGameOverOverlay(BuildContext context) {
  assert(_exit_overlayEntry != null);
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
  Overlay.of(context).insert(_exit_overlayEntry!);
}
void hideQCardOverlay() {
  if(qCardOverlayEntry != null){
    qCardOverlayEntry?.remove();
    qCardOverlayEntry = null;
  }
}
void hideGameOverOverlay() {
  _exit_overlayEntry?.remove();
  _exit_overlayEntry = null;
}
void exitOnPressed(context, appState){
  hideQCardOverlay();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Exit'),
        content: const Text(
          'Do you really want to exit game?',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Exit'),
            onPressed: () async{
              await exitGameRoom(context, appState);
            },
          ),
        ],
      );
    },
  );
}
Future<void> exitGameRoom(BuildContext context, appState) async {
  try{
    hideQCardOverlay();
    if(appState.isHost){
      appState.removeGameRoom().then((value){
        context.go('/');
      });
    }else{
      appState.removePlayer().then((value){
        context.go('/');
      });
    }
  }catch(e){
    print('====exitGameRoom====');
    print(e);
  }
}