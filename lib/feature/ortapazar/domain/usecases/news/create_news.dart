import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/news_repository.dart';

class CreateNewsUseCase extends UseCase<String?, CreateNewsParams> {
  final NewsRepository newsRepository;

  CreateNewsUseCase({
    required this.newsRepository,
  });

  @override
  Future<Either<Failure, String?>> call(
    CreateNewsParams params,
  ) async {
    final result = await newsRepository.createNews(
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

class CreateNewsParams {
  final String collectionId;
  final String documentId;
  final Map<String, dynamic> data;

  CreateNewsParams({
    required this.collectionId,
    required this.documentId,
    required this.data,
  });
}
