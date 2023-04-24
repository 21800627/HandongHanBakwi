import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/widgets/QCard.dart';
import 'package:handong_han_bakwi/widgets/Dice.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Dice(),
            // ctrl + / 로 주석 해제, 주석 처리
            // QCard(
            //   frontWidget: Container(
            //     width: 300,
            //     height: 200,
            //     child: Text('Front of Card'),
            //     decoration: BoxDecoration(
            //       color: Colors.blue,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     padding: EdgeInsets.all(16),
            //   ),
            //   backWidget: Container(
            //     width: 300,
            //     height: 200,
            //     child: Text('Back of Card'),
            //     decoration: BoxDecoration(
            //       color: Colors.red,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     padding: EdgeInsets.all(16),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}