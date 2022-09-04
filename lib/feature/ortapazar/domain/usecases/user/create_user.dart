import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/news_repository.dart';
import '../../repositories/user_repository.dart';

class CreateUserUseCase extends UseCase<String?, CreateUserParams> {
  final UserRepository userRepository;

  CreateUserUseCase({
    required this.userRepository,
  });

  @override
  Future<Either<Failure, String?>> call(
    CreateUserParams params,
  ) async {
    final result = await userRepository.createUser(
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

class CreateUserParams {
  final String collectionId;
  final String documentId;
  final Map<String, dynamic> data;

  CreateUserParams({
    required this.collectionId,
    required this.documentId,
    required this.data,
  });
}
