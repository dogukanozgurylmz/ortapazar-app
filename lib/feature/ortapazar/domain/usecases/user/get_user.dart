import 'package:ortapazar/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/news_entity.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/user_entity.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../repositories/user_repository.dart';

class GetUserUseCase extends UseCase<UserEntity, GetUserParams> {
  final UserRepository userRepository;

  GetUserUseCase({
    required this.userRepository,
  });

  @override
  Future<Either<Failure, UserEntity>> call(GetUserParams params) async {
    final result = await userRepository.getUser(
      params.collectionId,
      params.documentId,
    );
    final either = result.fold((l) => l, (r) => r);
    if (either is UserEntity && either.toString().isNotEmpty) {
      return Right(either);
    }
    return Left(ServerFailure());
  }
}

class GetUserParams {
  final String collectionId;
  final String documentId;

  GetUserParams({
    required this.collectionId,
    required this.documentId,
  });
}
