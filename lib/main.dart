// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_todo_demo/pages/sign_in_page.dart';
import 'package:flutter_todo_demo/pages/todo_list_page.dart';
import 'package:flutter/material.dart';

import 'secret/firebase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  final firebases = Firebases(
    auth: FirebaseAuth.instance,
    store: FirebaseFirestore.instance,
  );
  runApp(MyApp(firebases));
}

class Firebases {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  Firebases({
    required this.auth,
    required this.store,
  });
}

class MyApp extends StatelessWidget {
  const MyApp(
    this.firebases, {
    Key? key,
  }) : super(key: key);

  final Firebases firebases;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Todo Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      initialRoute: firebases.auth.currentUser == null
          ? SignInPage.routeName
          : TodoListPage.routeName,
      routes: {
        SignInPage.routeName: (context) => SignInPage(firebases),
        TodoListPage.routeName: (context) => TodoListPage(firebases),
        TodoDetailsPage.routeName: (context) => const TodoDetailsPage(),
      },
    );
  }
}
