import 'package:ortapazar/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/saved_news_entity.dart';
import '../../domain/repositories/saved_news_repository.dart';
import '../datasource/saved_news_datasource.dart';
import '../model/saved_news_model.dart';

typedef _GetSavedNewsList = Future<List<SavedNewsEntity>> Function();
typedef _CreateSavedNews = Future<String?> Function();
typedef _UpdateSavedNews = Future<String?> Function();
typedef _DeleteSavedNews = Future<String?> Function();

class SavedNewsRepositoryImpl implements SavedNewsRepository {
  final SavedNewsDataSource _savedNewsDatasource;

  SavedNewsRepositoryImpl(SavedNewsDataSource savedNewsDataSource)
      : _savedNewsDatasource = savedNewsDataSource;

  @override
  Future<Either<Failure, List<SavedNewsEntity>>> getSavedNewsList(
      String collectionId, int? limit) {
    return _getSavedNewsList(() async {
      final List<SavedNewsModel> result =
          await _savedNewsDatasource.getSavedNewsList(
        collectionId,
        limit,
      );
      final newsList = result
          .map((e) => SavedNewsEntity(
                id: e.id,
                newsId: e.newsId,
              ))
          .toList();
      return newsList;
    });
  }

  @override
  Future<Either<Failure, String?>> createSavedNews(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) {
    return _createSavedNews(
      () async {
        final String? result = await _savedNewsDatasource.createSavedNews(
          collectionId,
          data,
        );
        return result;
      },
    );
  }

  @override
  Future<Either<Failure, String?>> updateSavedNews(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) {
    return _updateSavedNews(
      () async {
        final String? result = await _savedNewsDatasource.updateSavedNews(
          collectionId,
          documentId,
          data,
        );
        return result;
      },
    );
  }

  @override
  Future<Either<Failure, String?>> deleteSavedNews(
    String collectionId,
    String documentId,
  ) {
    return _deleteSavedNews(
      () async {
        final String? result = await _savedNewsDatasource.deleteSavedNews(
          collectionId,
          documentId,
        );
        return result;
      },
    );
  }

  Future<Either<Failure, List<SavedNewsEntity>>> _getSavedNewsList(
    _GetSavedNewsList getSavedNewsList,
  ) async {
    try {
      final result = await getSavedNewsList();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, String?>> _createSavedNews(
    _CreateSavedNews createSavedNews,
  ) async {
    try {
      final result = await createSavedNews();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, String?>> _updateSavedNews(
    _UpdateSavedNews updateSavedNews,
  ) async {
    try {
      final result = await updateSavedNews();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, String?>> _deleteSavedNews(
    _DeleteSavedNews deleteSavedNews,
  ) async {
    try {
      final result = await deleteSavedNews();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
