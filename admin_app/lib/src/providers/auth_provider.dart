import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  Future<UserCredential> emailSignIn(
      {@required String email, @required String pass}) async {
    final userRegister =
        await auth.signInWithEmailAndPassword(email: email, password: pass);

    return userRegister;
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();

    await auth.signOut().then((value) async {
      await sharedPreferences.clear().then((value) {
        return;
      });
    });
  }

  Future<void> resetPass(String email) async {
    try {
      return await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }
}
