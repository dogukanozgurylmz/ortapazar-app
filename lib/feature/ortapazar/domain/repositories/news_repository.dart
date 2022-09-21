import 'package:dartz/dartz.dart';
import 'package:ortapazar/core/errors/failures.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/news_entity.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsEntity>>> getNewsList(
      String collectionId, int? limit);
  Future<Either<Failure, List<NewsEntity>>> getNewsByUId(
      String collectionId, String query);
  Future<Either<Failure, List<NewsEntity>>> getNewsByCreatedAt(
      String collectionId, String query);
  Future<Either<Failure, String?>> createNews(
      String collectionId, String documentId, Map<String, dynamic> data);
  Future<Either<Failure, String?>> updateNews(
      String collectionId, String documentId, Map<String, dynamic> data);
}
