import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class QCard extends StatelessWidget {
  String message;
  QCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.5;
    double cardHeight = MediaQuery.of(context).size.height * 0.35;

    return Card(
      elevation: 0.0,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlipCard(
            direction: FlipDirection.HORIZONTAL,
            side: CardSide.FRONT,
            speed: 500,
            onFlipDone: (status) {
              print(status);
            },
            front: Container(
              width: cardWidth,
              height: cardHeight,
              //padding: EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Qback.png'),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Text(
                  this.message,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
              ),

            ),
            back: Container(
              width: cardWidth,
              height: cardHeight,
              //padding: EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Qback.png'),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}







