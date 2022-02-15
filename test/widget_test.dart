import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_todo_demo/main.dart';
import 'package:flutter_todo_demo/pages/sign_in_page.dart';
import 'package:flutter_todo_demo/pages/todo_list_page.dart';

void main() {
  testWidgets('initPage should be SignInPage', (tester) async {
    final deps = Firebases(
      auth: MockFirebaseAuth(),
      store: FakeFirebaseFirestore(),
    );
    await tester.pumpWidget(MyApp(deps));
    await tester.pumpAndSettle();
    expect(find.byType(SignInPage), findsOneWidget);
  });
  testWidgets('signout', (tester) async {
    final deps = Firebases(
      auth: MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(displayName: 'I am mock user'),
      ),
      store: FakeFirebaseFirestore(),
    );
    await tester.pumpWidget(MyApp(deps));
    await tester.pumpAndSettle();
    expect(find.byType(TodoListPage), findsOneWidget);
    expect(find.textContaining('I am mock user'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    expect(find.byType(SignInPage), findsOneWidget);
  });
  testWidgets('todo list page1', (tester) async {
    final deps = Firebases(
      auth: MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(displayName: 'I am mock user'),
      ),
      store: FakeFirebaseFirestore(),
    );

    final todos = deps.store.collection('todos');
    todos.add({
      'title': 'Hello1',
      'memo': 'World1',
    });
    todos.add({
      'title': 'Hello2',
      'memo': 'World2',
    });
    await tester.pumpWidget(MyApp(deps));
    await tester.pumpAndSettle();

    expect(find.byType(TodoListPage), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.text('Hello1'), findsOneWidget);
    expect(find.text('Hello2'), findsOneWidget);
  });

  testWidgets('todo details page', (tester) async {
    final deps = Firebases(
      auth: MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(displayName: 'I am mock user'),
      ),
      store: FakeFirebaseFirestore(),
    );

    final todos = deps.store.collection('todos');
    todos.add({
      'title': 'Hello1',
      'memo': 'World1',
    });
    await tester.pumpWidget(MyApp(deps));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(find.byType(TodoDetailsPage), findsOneWidget);
  });
}
