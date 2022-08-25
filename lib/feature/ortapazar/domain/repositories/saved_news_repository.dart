import 'package:dartz/dartz.dart';
import 'package:ortapazar/core/errors/failures.dart';

import '../entities/saved_news_entity.dart';

abstract class SavedNewsRepository {
  Future<Either<Failure, List<SavedNewsEntity>>> getSavedNewsList(
    String collectionId,
    int? limit,
  );
  Future<Either<Failure, String?>> createSavedNews(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, String?>> updateSavedNews(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, String?>> deleteSavedNews(
    String collectionId,
    String documentId,
  );
}
