import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/news_repository.dart';

class UpdateNewsUseCase extends UseCase<String?, UpdateNewsParams> {
  final NewsRepository newsRepository;

  UpdateNewsUseCase({
    required this.newsRepository,
  });

  @override
  Future<Either<Failure, String?>> call(
    UpdateNewsParams params,
  ) async {
    final result = await newsRepository.updateNews(
      params.collectionId,
      params.documentId,
      params.data,
    );

    final either = result.fold((l) => l, (r) => r);

    if (either is String && either.isNotEmpty) {
      return Right(either);
    }

    return Left(ServerFailure());
  }
}

class UpdateNewsParams {
  final String collectionId;
  final String documentId;
  final Map<String, dynamic> data;

  UpdateNewsParams({
    required this.collectionId,
    required this.documentId,
    required this.data,
  });
}
