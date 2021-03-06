import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo_demo/common/utils.dart';
import 'package:flutter_todo_demo/main.dart';
import 'package:flutter_todo_demo/model/types.dart';
import 'package:flutter_todo_demo/pages/sign_in_page.dart';
import 'package:flutter_todo_demo/pages/todo_details_page.dart';
import 'package:flutter/material.dart';

export 'todo_details_page.dart';

class TodoListPage extends StatefulWidget {
  static const routeName = '/todo_list';
  const TodoListPage(
    this.firebases, {
    Key? key,
  }) : super(key: key);

  final Firebases firebases;

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late final todos = widget.firebases.store.collection('todos');

  late StreamSubscription subs;

  @override
  void initState() {
    super.initState();
    subs = widget.firebases.auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          SignInPage.routeName,
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    subs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = widget.firebases.auth;
    final uid = auth.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<User?>(
          stream: auth.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('${snapshot.data!.displayName}님 반가워요.');
            }
            return const Text('Todo List');
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await auth.signOut();
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: todos.where('uid', isEqualTo: uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final docs = snapshot.data!.docs;
              return GridView.builder(
                itemCount: docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: max(1, constraints.maxWidth ~/ 250),
                  mainAxisExtent: 100,
                ),
                itemBuilder: (context, index) {
                  final item = docs[index];
                  final data = item.data();
                  final todo = Todo(
                    uid: auth.currentUser!.uid,
                    id: item.id,
                    title: data['title'],
                    memo: data['memo'],
                  );
                  return SizedBox(
                    child: Card(
                      child: ListTile(
                        title: Text(todo.title ?? ''),
                        onTap: () async {
                          _details(context, todo);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          _details(context, Todo(uid: uid));
        },
      ),
    );
  }

  Future<void> _details(BuildContext context, Todo todo) async {
    final result = await Navigator.pushNamed(
      context,
      TodoDetailsPage.routeName,
      arguments: todo,
    ) as Todo?;
    if (result == null) {
      todos.doc(todo.id).delete();
      showSnackbar(context, '메모를 삭제했습니다.');
    } else {
      if (result.id == null) {
        todos.add(result.toJson());
      } else {
        todos.doc(result.id).update(result.toJson());
      }
    }
  }
}
