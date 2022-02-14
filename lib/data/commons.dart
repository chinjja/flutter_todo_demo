import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo_demo/secret/oauth_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static const u = Uuid();

  static Future<UserCredential?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      clientId: OAutoConfig.appClientId,
    );
    final user = await googleSignIn.signIn();
    final auth = await user!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  static String uuid() {
    return u.v4();
  }
}
