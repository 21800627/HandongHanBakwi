import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class QCard extends StatefulWidget {
  final String koreanMessage;
  final String englishMessage;

  QCard({Key? key, required this.koreanMessage, required this.englishMessage})
      : super(key: key);

  @override
  _QCardState createState() => _QCardState();
}

class _QCardState extends State<QCard> {
  bool isKorean = false; // Start with English

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
            flipOnTouch: true,
            front: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Qback.png'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child:Text(
                        widget.englishMessage,
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 16), // Adjust the spacing
                    Text(
                      widget.koreanMessage,
                      style: Theme.of(context).textTheme.subtitle2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            back: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Qback.png'),
                  fit: BoxFit.fill,
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