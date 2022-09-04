import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/user_repository.dart';

class UpdateUserUseCase extends UseCase<String?, UpdateUserParams> {
  final UserRepository userRepository;

  UpdateUserUseCase({
    required this.userRepository,
  });

  @override
  Future<Either<Failure, String?>> call(
    UpdateUserParams params,
  ) async {
    final result = await userRepository.updateUser(
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

class UpdateUserParams {
  final String collectionId;
  final String documentId;
  final Map<String, dynamic> data;

  UpdateUserParams({
    required this.collectionId,
    required this.documentId,
    required this.data,
  });
}
