import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handong_han_bakwi/src/BoardUI.dart';
import 'package:handong_han_bakwi/src/Board_2_UI.dart';
import 'package:handong_han_bakwi/src/DiceUI.dart';
import 'package:handong_han_bakwi/src/HomeUI.dart';
import 'package:handong_han_bakwi/src/HostGameUI.dart';
import 'package:handong_han_bakwi/src/MultiGameUI.dart';
import 'package:handong_han_bakwi/src/WaitingGameUI.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/GAME.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => runApp(MyApp()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    //Game game= Game();

    return ChangeNotifierProvider(
      create: (_) => Game(),
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Handong Han Bakwi',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => const HomeScreen(),
            '/diceExample': (context) => const DiceScreen(),
            // '/board_2_Example': (context) => const Board_2_Screen(),
            '/board_2_Example': (_) => ChangeNotifierProvider.value(
                value: Provider.of<Game>(context, listen: true),
              child: Consumer<Game>(
                builder: (context, game, _) => Board_2_Screen(
                  roundNum: game.roundNum,
                  roundStep: 39,
                  playerNum: game.playerNum,
                ),
              ),
            ),
            // '/board_2_Example': (context) => Consumer<Game>(
            //   builder: (context, game, _) => Board_2_Screen(
            //     roundNum: game.roundNum,
            //     roundStep: 39,
            //     playerNum: game.playerNum,
            //   ),
            // ),
            '/boardExample': (context) => const BoardScreen(),
            // '/rankingExample': (context) => const RankingScreen(),
            '/rankingExample': (context) => const BoardScreen(),
            '/multiGameExample': (_) => ChangeNotifierProvider.value(value: Provider.of<Game>(context, listen: true), child: MultiGameScreen()),
            '/HostGamePage' : (context) => const HostGamePage(),
            '/WaitingPage' : (context) => const WaitingGameScreen(),
          },
        );
      }
    );
  }
}