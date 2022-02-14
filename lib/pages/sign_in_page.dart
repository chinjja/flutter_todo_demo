import 'package:flutter_todo_demo/data/commons.dart';
import 'package:flutter_todo_demo/pages/todo_list_page.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/sign_in';
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 40,
        ),
        child: SizedBox.expand(
          child: Column(
            children: [
              _content(),
              _googleSignButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/firebase_logo.png',
            height: 160,
          ),
          const SizedBox(height: 20),
          const Text(
            'FlutterFire',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 40,
            ),
          ),
          const Text(
            'Authentication',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleSignButton() {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            shape: MaterialStateProperty.all(const StadiumBorder()),
            padding: MaterialStateProperty.all(const EdgeInsets.all(10))),
        onPressed: () async {
          try {
            await Utils.signInWithGoogle();
            Navigator.pushNamedAndRemoveUntil(
              context,
              TodoListPage.routeName,
              (route) => false,
            );
          } catch (e) {
            print('ex $e');
          }
        },
        icon: Image.asset(
          'assets/images/google_logo.png',
          height: 35,
        ),
        label: const Text('Sign In with Google'),
      ),
    );
  }
}
