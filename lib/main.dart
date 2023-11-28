import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:handong_han_bakwi/src/RankingUI.dart';
import 'package:handong_han_bakwi/src/StartGameUI.dart';
import 'package:handong_han_bakwi/src/WaitingRoomUI.dart';

import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';               // new

import 'models/GAME.dart';

import 'package:handong_han_bakwi/src/Board_2_UI.dart';
import 'package:handong_han_bakwi/src/HomeUI.dart';
import 'package:handong_han_bakwi/src/HostGameUI.dart';

import 'app_state.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const MyApp()),
  )));

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const MyApp()),
  ));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString());
                })),
                AuthStateChangeAction(((context, state) {
                  if (state is SignedIn || state is UserCreated) {
                    var user = (state is SignedIn)
                        ? state.user
                        : (state as UserCreated).credential.user;
                    if (user == null) {
                      return;
                    }
                    if (state is UserCreated) {
                      user.updateDisplayName(user.email!.split('@')[0]);
                    }
                    // if (!user.emailVerified) {
                    //   user.sendEmailVerification();
                    //   const snackBar = SnackBar(
                    //       content: Text(
                    //           'Please check your email to verify your email address'));
                    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // }
                    context.pushReplacement('/');
                  }
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.pathParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            );
          },
        ),
        GoRoute(
          path: 'host-game',
          builder: (context, state) {
            return HostGamePage();
          },
        ),
        GoRoute(
          path: 'waiting-room/:hostKey',
          builder: (context, state) {
            final String hostKey = state.pathParameters['hostKey'].toString();
            return WaitingRoomPage();
          },
        ),
        GoRoute(
          path: 'start-game',
          builder: (context, state){
            final String hostKey = state.pathParameters['hostKey'].toString();
            return StartGamePage();
            // return ChangeNotifierProvider.value(
            //   value: Game(roundNum: 1,playerNum: 2),
            //   child: Consumer<Game>(
            //     builder: (context, game, _) => StartGamePage(hostKey: hostKey),
            //   ),
            // );
          }
        ),
        GoRoute(
          //path: 'ranking/:hostKey',
          path: 'ranking',
          builder: (context, state){
            final String hostKey = state.pathParameters['hostKey'].toString();
            return RankingPage();
          }
        ),
        // GoRoute(
        //   path: 'start-game/:hostKey',
        //   builder: (context, state){
        //     final String hostKey = state.pathParameters['hostKey'].toString();
        //     return ChangeNotifierProvider.value(
        //       value: Game(roundNum: 1,playerNum: 2),
        //       child: Consumer<Game>(
        //         builder: (context, game, _) => StartGamePage(
        //           roundNum: 1,
        //           roundStep: 39,
        //           playerNum: 4,
        //         ),
        //       ),
        //     );
        //   }
        // ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ApplicationState(),
      builder: (context, snapshot) {
        return MaterialApp.router(
            title: 'Handong Han Bakwi',
            theme: _buildTheme(Brightness.light),
            routerConfig: _router,
        );
      }
    );
  }
  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.blackHanSansTextTheme(baseTheme.textTheme),
      //textTheme: ,
      backgroundColor: Color(0xffFAFAFA),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          backgroundColor: const Color(0xff00A3CE),
          side: const BorderSide(width: 2.0, color: Color(0xff383838)),
          padding: EdgeInsets.fromLTRB(8, 16, 8, 16)
        ),
      ),
    );
  }
}

