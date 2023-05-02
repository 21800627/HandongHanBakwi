import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class QCard extends StatelessWidget {
  const QCard({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return _renderContent(context); //Stack(
    //   fit: StackFit.expand,
    //   children: <Widget>[
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: <Widget>[
    //         Expanded(
    //           flex: 1,
    //           child: _renderContent(context),
    //         ),
    //         Expanded(
    //           flex: 1,
    //           child: Container(),
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }

  _renderContent(context) {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 0.0,
        margin:
            EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0, bottom: 0.0),
        color: Color(0x00000000),
        child: FlipCard(
          direction: FlipDirection.HORIZONTAL,
          side: CardSide.FRONT,
          speed: 1000,
          onFlipDone: (status) {
            print(status);
          },
          front: Container(
            decoration: BoxDecoration(
              color: Color(0xFF006666),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Front', style: Theme.of(context).textTheme.headline1),
                Text('Click here to flip back',
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          ),
          back: Container(
            decoration: BoxDecoration(
              color: Color(0xFF006666),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Back', style: Theme.of(context).textTheme.headline1),
                Text('Click here to flip front',
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
