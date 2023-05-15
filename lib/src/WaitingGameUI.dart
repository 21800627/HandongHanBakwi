
import 'package:flutter/material.dart';

class WaitingGameScreen extends StatefulWidget {
  const WaitingGameScreen({Key? key}) : super(key: key);

  @override
  State<WaitingGameScreen> createState() => _WaitingGameScreenState();
}


class _WaitingGameScreenState extends State<WaitingGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Exit App"),
        ),
        body: Container(
            child:Center(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/'); // go to Home: Player
                },
                child: Text("Exit App"),
              ),
            )
        )
    );
  }
}

