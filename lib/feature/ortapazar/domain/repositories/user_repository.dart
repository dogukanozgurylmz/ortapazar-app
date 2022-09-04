import 'package:dartz/dartz.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/user_entity.dart';

import '../../../../core/errors/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers(
    String collectionId,
    int? limit,
  );
  Future<Either<Failure, UserEntity>> getUser(
    String collectionId,
    String documentId,
  );
  Future<Either<Failure, String?>> createUser(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, String?>> updateUser(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  );
}
