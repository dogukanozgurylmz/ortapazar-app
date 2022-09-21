import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ortapazar/feature/ortapazar/data/model/news_model.dart';

import 'firebase_data_manager.dart';
import 'ortapazar_database.dart';

abstract class NewsDataSource {
  Future<List<NewsModel>> getNewsList(String collectionId, int? limit);
  Future<List<NewsModel>> getNewsByUId(String collectionId, String query);
  Future<List<NewsModel>> getNewsByCreatedAt(String collectionId, String query);
  Future<String?> createNews(
      String collectionId, String documentId, Map<String, dynamic> data);
  Future<String?> updateNews(
      String collectionId, String documentId, Map<String, dynamic> data);
}

class NewsDataSourceImpl extends FirebaseDataManager implements NewsDataSource {
  @override
  Future<List<NewsModel>> getNewsList(
    String collectionId,
    int? limit,
  ) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firestore.collection(collectionId).get();
    var list =
        querySnapshot.docs.map((e) => NewsModel.fromJson(e.data())).toList();

    if (list.isEmpty) {
      throw Exception('No news found');
    }
    return list;
  }

  @override
  Future<List<NewsModel>> getNewsByUId(
    String collectionId,
    String query,
  ) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection(collectionId)
        .where('user_id', isEqualTo: query)
        .get();
    var list =
        querySnapshot.docs.map((e) => NewsModel.fromJson(e.data())).toList();

    if (list.isEmpty) {
      throw Exception('No news found');
    }
    return list;
  }

  @override
  Future<List<NewsModel>> getNewsByCreatedAt(
    String collectionId,
    String query,
  ) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection(collectionId)
        // .orderBy('created_at')
        // .orderBy(FieldPath.documentId)
        .where('is_confirm', isEqualTo: true)
        // .limitToLast(100)
        .get();
    var list =
        querySnapshot.docs.map((e) => NewsModel.fromJson(e.data())).toList();

    if (list.isEmpty) {
      throw Exception('No news found');
    }
    return list;
  }

  @override
  Future<String?> createNews(
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
  Future<String?> updateNews(
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
