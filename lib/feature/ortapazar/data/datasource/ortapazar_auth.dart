import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/firebase_auth_manager.dart';

class OrtapazarAuth extends FirebaseAuthManager {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOutGoogle() async {
    await firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await facebookAuth.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return firebaseAuth.signInWithCredential(facebookAuthCredential);
  }

  Future<void> signOutFacebook() async {
    await firebaseAuth.signOut();
    await facebookAuth.logOut();
  }
}
