import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class QCard extends StatelessWidget {
  String koreanMessage;
  String englishMessage;

  QCard({super.key, required this.koreanMessage, required this.englishMessage});

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.5;
    double cardHeight = MediaQuery.of(context).size.height * 0.35;

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
              padding: EdgeInsets.all(20),


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
                  // Display either Korean or English message based on user preference
                  // For example, you can check a language variable and show the corresponding message
                  // This is just a placeholder, adjust according to your actual logic
                  "Korean Language ? ${koreanMessage} : ${englishMessage}",
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            back: Container(
              width: cardWidth,
              height: cardHeight,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(

                image: DecorationImage(
                  image: AssetImage('assets/images/Qback.png'),
                  fit: BoxFit.fill,
                ),

                //color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}