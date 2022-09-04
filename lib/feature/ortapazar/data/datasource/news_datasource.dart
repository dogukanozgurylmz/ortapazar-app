import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ortapazar/feature/ortapazar/data/model/news_model.dart';

import 'firebase_data_manager.dart';
import 'ortapazar_database.dart';

abstract class NewsDataSource {
  Future<List<NewsModel>> getNewsList(
    String collectionId,
    int? limit,
  );
  Future<String?> createNews(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  );
  Future<String?> updateNews(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  );
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
      throw Exception('No days found');
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
