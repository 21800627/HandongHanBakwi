// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width * 0.25,
              child: OutlinedButton(
                  onPressed: () {
                    !loggedIn ? context.push('/sign-in') : signOut();
                  },
                  child: !loggedIn ? const Text('Log In') : const Text('Log out')),
            ),
            Visibility(
                visible: loggedIn,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: OutlinedButton(
                      onPressed: () {
                        context.push('/profile');
                        if (FirebaseAuth.instance.currentUser != null) {
                          print(FirebaseAuth.instance.currentUser?.uid);
                        }
                      },
                      child: const Text('Profile')),
                )
            ),
          ],
        ),
        Visibility(
            visible: !loggedIn,
            child: Container(
              margin: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width * 0.25,
              child: OutlinedButton(
                  onPressed: () {
                    context.push('/tutorial');
                  },
                  child: const Text('Tutorial')),
            )
        ),
      ],
    );
  }
}