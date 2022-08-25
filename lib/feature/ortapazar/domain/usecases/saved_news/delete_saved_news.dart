import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/saved_news_repository.dart';

class DeleteSavedNewsUseCase extends UseCase<String?, DeleteSavedNewsParams> {
  final SavedNewsRepository savedNewsRepository;

  DeleteSavedNewsUseCase({
    required this.savedNewsRepository,
  });

  @override
  Future<Either<Failure, String?>> call(
    DeleteSavedNewsParams params,
  ) async {
    final result = await savedNewsRepository.deleteSavedNews(
      params.collectionId,
      params.documentId,
    );

    final either = result.fold((l) => l, (r) => r);

    if (either is String && either.isNotEmpty) {
      return Right(either);
    }

    return Left(ServerFailure());
  }
}

class DeleteSavedNewsParams {
  final String collectionId;
  final String documentId;

  DeleteSavedNewsParams({
    required this.collectionId,
    required this.documentId,
  });
}
