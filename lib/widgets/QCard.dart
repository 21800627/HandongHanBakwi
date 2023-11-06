import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class QCard extends StatelessWidget {
  String message;
  QCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.5;
    double cardHeight = MediaQuery.of(context).size.height * 0.5;

    return Card(
      elevation: 0.0,
      //color: Colors.transparent,
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
              padding: EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Qback.png'),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Text(this.message, style: Theme.of(context).textTheme.headline6),
              ),
            ),
            back: Container(
              width: cardWidth,
              height: cardHeight,
              padding: EdgeInsets.all(32.0),
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








/* 기존 코드
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';


class QCard extends StatelessWidget {
  String message;
  QCard({super.key, required this.message});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Colors.transparent,
      // margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0, bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlipCard(
            direction: FlipDirection.HORIZONTAL,
            side: CardSide.FRONT,
            speed: 1000,
            onFlipDone: (status) {
              print(status);
            },
            front: Container(
              width: MediaQuery.of(context).size.width*0.5,
              height: MediaQuery.of(context).size.height*0.5,
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 32.0, bottom: 32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(this.message, style: Theme.of(context).textTheme.headline6),
                  // Text('Click here to flip back',
                  //     style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
            back: Container(
              width: MediaQuery.of(context).size.width*0.5,
              height: MediaQuery.of(context).size.height*0.5,
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 32.0, bottom: 32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.question_answer_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

 */
