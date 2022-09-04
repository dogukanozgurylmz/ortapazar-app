import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/firebase_data_manager.dart';

import '../model/saved_news_model.dart';
import 'ortapazar_database.dart';

abstract class SavedNewsDataSource {
  Future<List<SavedNewsModel>> getSavedNewsList(
    String collectionId,
    int? limit,
  );
  Future<String?> createSavedNews(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  );
  Future<String?> updateSavedNews(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  );
  Future<String?> deleteSavedNews(
    String collectionId,
    String documentId,
  );
}

class SavedNewsDataSourceImpl extends FirebaseDataManager
    implements SavedNewsDataSource {
  @override
  Future<List<SavedNewsModel>> getSavedNewsList(
    String collectionId,
    int? limit,
  ) async {
    // final result = firestore.collection(collectionId).get();
    var ref = firestore.collection(collectionId).limit(limit ?? 100);
    QuerySnapshot result = await ref.get();
    HashMap<String, SavedNewsModel> eventsHashMap =
        HashMap<String, SavedNewsModel>();

    for (var element in result.docs) {
      eventsHashMap.putIfAbsent(
        element['id'],
        () => SavedNewsModel(
          id: element['id'],
          userId: element['user_id'],
          newsId: element['news_id'],
        ),
      );
    }
    if (eventsHashMap.isEmpty) {
      throw Exception('No days found');
    }
    return eventsHashMap.values.toList();
  }

  @override
  Future<String?> createSavedNews(
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
  Future<String?> updateSavedNews(
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

  @override
  Future<String?> deleteSavedNews(
    String collectionId,
    String documentId,
  ) async {
    return await OrtapazarDatabase().deleteDatabaseDocument(
      collectionId,
      documentId,
    );
  }
}
