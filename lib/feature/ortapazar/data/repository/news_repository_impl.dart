import 'package:ortapazar/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ortapazar/feature/ortapazar/data/model/news_model.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/news_entity.dart';

import '../../domain/repositories/news_repository.dart';
import '../datasource/news_datasource.dart';

typedef _GetNewsList = Future<List<NewsEntity>> Function();
typedef _GetNewsById = Future<List<NewsEntity>> Function();
typedef _GetNewsByCreatedAt = Future<List<NewsEntity>> Function();
typedef _CreateNews = Future<String?> Function();
typedef _UpdateNews = Future<String?> Function();

class NewsRepositoryImpl implements NewsRepository {
  final NewsDataSource _newsDatasource;

  NewsRepositoryImpl(NewsDataSource newsDataSource)
      : _newsDatasource = newsDataSource;

  @override
  Future<Either<Failure, List<NewsEntity>>> getNewsList(
      String collectionId, int? limit) {
    return _getNewsList(() async {
      final List<NewsModel> result =
          await _newsDatasource.getNewsList(collectionId, limit);
      final newsList = result
          .map((e) => NewsEntity(
                id: e.id,
                userId: e.userId,
                title: e.title,
                content: e.content,
                image: e.image,
                addedDate: e.addedDate,
                isConfirm: e.isConfirm,
                createdAt: e.createdAt,
              ))
          .toList();
      return newsList;
    });
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getNewsByUId(
    String collectionId,
    String query,
  ) {
    return _getNewsByUId(() async {
      final List<NewsModel> result =
          await _newsDatasource.getNewsByUId(collectionId, query);
      final newsList = result
          .map((e) => NewsEntity(
                id: e.id,
                userId: e.userId,
                title: e.title,
                content: e.content,
                image: e.image,
                addedDate: e.addedDate,
                isConfirm: e.isConfirm,
                createdAt: e.createdAt,
              ))
          .toList();
      return newsList;
    });
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getNewsByCreatedAt(
    String collectionId,
    String query,
  ) {
    return _getNewsByCreatedAt(() async {
      final List<NewsModel> result =
          await _newsDatasource.getNewsByCreatedAt(collectionId, query);
      final newsList = result
          .map((e) => NewsEntity(
                id: e.id,
                userId: e.userId,
                title: e.title,
                content: e.content,
                image: e.image,
                addedDate: e.addedDate,
                isConfirm: e.isConfirm,
                createdAt: e.createdAt,
              ))
          .toList();
      return newsList;
    });
  }

  @override
  Future<Either<Failure, String?>> createNews(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) {
    return _createNews(
      () async {
        final String? result = await _newsDatasource.createNews(
          collectionId,
          documentId,
          data,
        );
        return result;
      },
    );
  }

  @override
  Future<Either<Failure, String?>> updateNews(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) {
    return _updateNews(
      () async {
        final String? result = await _newsDatasource.updateNews(
          collectionId,
          documentId,
          data,
        );
        return result;
      },
    );
  }

  Future<Either<Failure, List<NewsEntity>>> _getNewsList(
    _GetNewsList getNewsList,
  ) async {
    try {
      final result = await getNewsList();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, List<NewsEntity>>> _getNewsByUId(
    _GetNewsById getNewsById,
  ) async {
    try {
      final result = await getNewsById();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, List<NewsEntity>>> _getNewsByCreatedAt(
    _GetNewsByCreatedAt getNewsByCreatedAt,
  ) async {
    try {
      final result = await getNewsByCreatedAt();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, String?>> _createNews(
    _CreateNews createNews,
  ) async {
    try {
      final result = await createNews();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, String?>> _updateNews(
    _UpdateNews updateNews,
  ) async {
    try {
      final result = await updateNews();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
