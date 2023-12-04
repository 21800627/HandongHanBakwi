import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

import '../models/QUESTION.dart';


class QCard extends StatelessWidget {
  String koreanMessage;
  String englishMessage;
  int points;

  QCard({super.key, required this.koreanMessage, required this.englishMessage, required this.points});

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.5;
    double cardHeight = MediaQuery.of(context).size.height * 0.6;

    return Card(
      elevation: 0.0,
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
              padding: EdgeInsets.all(25),

              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Qback.png'),
                  fit: BoxFit.fill,
                ),
                //color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),

              child: Center(
                child: Text(
                  "${koreanMessage} \n\n ${englishMessage}",
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            back: Container(
              width: cardWidth,
              height: cardHeight,
              padding: EdgeInsets.all(25),

              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Qback.png'),
                  fit: BoxFit.fill,
                ),
                //color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Text(
                  "${points}",
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}