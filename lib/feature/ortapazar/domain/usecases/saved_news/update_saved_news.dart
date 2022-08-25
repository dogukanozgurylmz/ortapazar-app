import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/saved_news_repository.dart';

class UpdateSavedNewsUseCase extends UseCase<String?, UpdateSavedNewsParams> {
  final SavedNewsRepository savedNewsRepository;

  UpdateSavedNewsUseCase({
    required this.savedNewsRepository,
  });

  @override
  Future<Either<Failure, String?>> call(
    UpdateSavedNewsParams params,
  ) async {
    final result = await savedNewsRepository.updateSavedNews(
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

class UpdateSavedNewsParams {
  final String collectionId;
  final String documentId;
  final Map<String, dynamic> data;

  UpdateSavedNewsParams({
    required this.collectionId,
    required this.documentId,
    required this.data,
  });
}
