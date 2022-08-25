import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/saved_news_repository.dart';

class CreateSavedNewsUseCase extends UseCase<String?, CreateSavedNewsParams> {
  final SavedNewsRepository savedNewsRepository;

  CreateSavedNewsUseCase({
    required this.savedNewsRepository,
  });

  @override
  Future<Either<Failure, String?>> call(
    CreateSavedNewsParams params,
  ) async {
    final result = await savedNewsRepository.createSavedNews(
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

class CreateSavedNewsParams {
  final String collectionId;
  final String documentId;
  final Map<String, dynamic> data;

  CreateSavedNewsParams({
    required this.collectionId,
    required this.documentId,
    required this.data,
  });
}
