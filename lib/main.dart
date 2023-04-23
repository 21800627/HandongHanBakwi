import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(title: 'Handong Han Bakwi~'),
    );
  }
}
