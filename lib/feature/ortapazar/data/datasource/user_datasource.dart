import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/ortapazar_database.dart';

import '../model/user_model.dart';

abstract class UserDataSource {
  Future<List<UserModel>> getUsers(
    String collectionId,
    int? limit,
  );
  Future<UserModel> getUser(
    String collectionId,
    String documentId,
  );
  Future<String?> createUser(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  );
  Future<String?> updateUser(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  );
}

class UserDataSourceImpl extends UserDataSource {
  @override
  Future<List<UserModel>> getUsers(
    String collectionId,
    int? limit,
  ) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await OrtapazarDatabase().firestore.collection(collectionId).get();
    var list =
        querySnapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();

    if (list.isEmpty) {
      throw Exception('No user');
    }
    return list;
  }

  @override
  Future<UserModel> getUser(
    String collectionId,
    String documentId,
  ) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await OrtapazarDatabase()
            .firestore
            .collection(collectionId)
            .doc(documentId)
            .get();
    Map<String, dynamic>? data = documentSnapshot.data();
    UserModel userModel = UserModel(
      id: data!['id'],
      displayName: data['display_name'],
      email: data['email'],
      phoneNumber: data['phone_number'],
      photoUrl: data['photo_url'],
      emailVerified: data['email_verified'],
    );
    return userModel;
  }

  @override
  Future<String?> createUser(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    return await OrtapazarDatabase().createDatabaseDocument(
      collectionId,
      documentId,
      data,
    );
  }

  @override
  Future<String?> updateUser(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    return await OrtapazarDatabase().updateDatabaseDocument(
      collectionId,
      documentId,
      data,
    );
  }
}
