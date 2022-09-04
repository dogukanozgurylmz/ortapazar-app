import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthManager {
  late FirebaseAuth firebaseAuth;
  late FacebookAuth facebookAuth;

  FirebaseAuthManager() {
    firebaseAuth = FirebaseAuth.instance;
    facebookAuth = FacebookAuth.instance;
  }
}
