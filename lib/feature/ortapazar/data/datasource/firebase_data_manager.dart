import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataManager {
  late FirebaseFirestore firestore;

  FirebaseDataManager() {
    firestore = FirebaseFirestore.instance;
  }
}

class OrtapazarDatabase extends FirebaseDataManager {
  Future<String?> createDatabaseDocument(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      Future<void> result =
          firestore.collection(collectionId).doc(documentId).set(data);
      if (result.toString().isNotEmpty) {
        return result.toString();
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      log(e.message.toString());
      return null;
    }
  }

  Future<String?> updateDatabaseDocument(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      Future<void> result =
          firestore.collection(collectionId).doc(documentId).update(data);
      if (result.toString().isNotEmpty) {
        return result.toString();
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      log(e.message.toString());
      return null;
    }
  }

  Future<String?> deleteDatabaseDocument(
    String collectionId,
    String documentId,
  ) async {
    try {
      Future<void> result =
          firestore.collection(collectionId).doc(documentId).delete();
      if (result.toString().isNotEmpty) {
        return result.toString();
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      log(e.message.toString());
      return null;
    }
  }
}
