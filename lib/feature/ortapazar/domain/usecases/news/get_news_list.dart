import 'package:ortapazar/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/news_entity.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../repositories/news_repository.dart';

class GetNewsListUseCase extends UseCase<List<NewsEntity>, GetNewsListParams> {
  final NewsRepository newsRepository;

  GetNewsListUseCase({
    required this.newsRepository,
  });

  @override
  Future<Either<Failure, List<NewsEntity>>> call(
      GetNewsListParams params) async {
    final result = await newsRepository.getNewsList(
      params.collectionId,
      params.limit,
    );
    final either = result.fold((l) => l, (r) => r);
    if (either is List<NewsEntity> && either.isNotEmpty) {
      return Right(either);
    }
    return Left(ServerFailure());
  }
}

class GetNewsListParams {
  final String collectionId;
  final int? limit;

  GetNewsListParams({
    required this.collectionId,
    required this.limit,
  });
}
