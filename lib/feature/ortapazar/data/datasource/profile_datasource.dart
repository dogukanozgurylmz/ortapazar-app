import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/ortapazar_auth.dart';
import 'package:ortapazar/feature/ortapazar/data/model/user_model.dart';

abstract class ProfileDataSource {
  Future<UserCredential> signInWithGoogle();
  Future<void> signOutGoogle();
  Future<UserCredential> signInWithFacebook();
  Future<void> signOutFacebook();
}

class ProfileDataSourceImpl extends ProfileDataSource {
  @override
  Future<UserCredential> signInWithFacebook() async {
    return await OrtapazarAuth().signInWithFacebook();
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    return await OrtapazarAuth().signInWithGoogle();
  }

  @override
  Future<void> signOutGoogle() async {
    return await OrtapazarAuth().signOutGoogle();
  }

  @override
  Future<void> signOutFacebook() async {
    return await OrtapazarAuth().signOutFacebook();
  }
}
