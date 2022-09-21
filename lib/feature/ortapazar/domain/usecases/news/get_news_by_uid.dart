import 'package:ortapazar/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/news_entity.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../repositories/news_repository.dart';

class GetNewsByUIdUseCase
    extends UseCase<List<NewsEntity>, GetNewsByUIdParams> {
  final NewsRepository newsRepository;

  GetNewsByUIdUseCase({
    required this.newsRepository,
  });

  @override
  Future<Either<Failure, List<NewsEntity>>> call(
      GetNewsByUIdParams params) async {
    final result = await newsRepository.getNewsByUId(
      params.collectionId,
      params.query,
    );
    final either = result.fold((l) => l, (r) => r);
    if (either is List<NewsEntity> && either.isNotEmpty) {
      return Right(either);
    }
    return Left(ServerFailure());
  }
}

class GetNewsByUIdParams {
  final String collectionId;
  final String query;

  GetNewsByUIdParams({
    required this.collectionId,
    required this.query,
  });
}
