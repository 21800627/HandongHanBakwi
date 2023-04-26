import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handong_han_bakwi/src/BoardUI.dart';
import 'package:handong_han_bakwi/src/HomeUI.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // set display only in landscape
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
    return MaterialApp(
      title: 'Handong Han Bakwi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const HomeScreen(),
        '/gameStart': (context) => const BoardScreen(),
      },
    );
  }
}