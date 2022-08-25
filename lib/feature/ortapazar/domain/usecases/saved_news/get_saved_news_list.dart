import 'package:ortapazar/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../entities/saved_news_entity.dart';
import '../../repositories/saved_news_repository.dart';

class GetSavedNewsListUseCase
    extends UseCase<List<SavedNewsEntity>, GetSavedNewsListParams> {
  final SavedNewsRepository savedNewsRepository;

  GetSavedNewsListUseCase({
    required this.savedNewsRepository,
  });

  @override
  Future<Either<Failure, List<SavedNewsEntity>>> call(
    GetSavedNewsListParams params,
  ) async {
    final result = await savedNewsRepository.getSavedNewsList(
      params.collectionId,
      params.limit,
    );
    final either = result.fold((l) => l, (r) => r);
    if (either is List<SavedNewsEntity> && either.isNotEmpty) {
      return Right(either);
    }
    return Left(ServerFailure());
  }
}

class GetSavedNewsListParams {
  final String collectionId;
  final int? limit;

  GetSavedNewsListParams({
    required this.collectionId,
    required this.limit,
  });
}
