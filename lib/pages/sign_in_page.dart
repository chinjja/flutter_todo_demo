import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo_demo/main.dart';
import 'package:flutter_todo_demo/pages/todo_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_demo/secret/oauth_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/sign_in';
  const SignInPage(this.firebases, {Key? key}) : super(key: key);

  final Firebases firebases;
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
            'Flutter Todo',
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
            await _signInWithGoogle();
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

  Future<UserCredential?> _signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      clientId: OAutoConfig.appClientId,
    );
    final user = await googleSignIn.signIn();
    final auth = await user!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    return await widget.firebases.auth.signInWithCredential(credential);
  }
}
