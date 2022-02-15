// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_todo_demo/pages/sign_in_page.dart';
import 'package:flutter_todo_demo/pages/todo_list_page.dart';
import 'package:flutter/material.dart';

import 'secret/firebase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Todo Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? SignInPage.routeName
          : TodoListPage.routeName,
      routes: {
        SignInPage.routeName: (context) => const SignInPage(),
        TodoListPage.routeName: (context) => const TodoListPage(),
        TodoDetailsPage.routeName: (context) => const TodoDetailsPage(),
      },
    );
  }
}
