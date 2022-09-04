import 'package:ortapazar/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ortapazar/feature/ortapazar/data/model/user_model.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/user_entity.dart';

import '../../domain/repositories/user_repository.dart';
import '../datasource/user_datasource.dart';

typedef _GetUsers = Future<List<UserEntity>> Function();
typedef _GetUser = Future<UserEntity> Function();
typedef _CreateUser = Future<String?> Function();
typedef _UpdateUser = Future<String?> Function();

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _userDatasource;

  UserRepositoryImpl(UserDataSource userDataSource)
      : _userDatasource = userDataSource;

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers(
    String collectionId,
    int? limit,
  ) {
    return _getUsers(() async {
      final List<UserModel> result =
          await _userDatasource.getUsers(collectionId, limit);
      final users = result
          .map((e) => UserEntity(
                id: e.id,
                displayName: e.displayName,
                email: e.email,
                emailVerified: e.emailVerified,
                phoneNumber: e.phoneNumber,
                photoUrl: e.photoUrl,
              ))
          .toList();
      return users;
    });
  }

  @override
  Future<Either<Failure, UserEntity>> getUser(
    String collectionId,
    String documentId,
  ) {
    return _getUser(
      () async {
        final UserModel result =
            await _userDatasource.getUser(collectionId, documentId);
        UserEntity user = UserEntity(
          id: result.id,
          displayName: result.displayName,
          email: result.email,
          phoneNumber: result.phoneNumber,
          photoUrl: result.photoUrl,
          emailVerified: result.emailVerified,
        );
        return user;
      },
    );
  }

  @override
  Future<Either<Failure, String?>> createUser(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) {
    return _createUser(
      () async {
        final String? result = await _userDatasource.createUser(
          collectionId,
          documentId,
          data,
        );
        return result;
      },
    );
  }

  @override
  Future<Either<Failure, String?>> updateUser(
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) {
    return _updateUser(
      () async {
        final String? result = await _userDatasource.updateUser(
          collectionId,
          documentId,
          data,
        );
        return result;
      },
    );
  }

  Future<Either<Failure, List<UserEntity>>> _getUsers(
    _GetUsers getUsers,
  ) async {
    try {
      final result = await getUsers();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, UserEntity>> _getUser(
    _GetUser getUser,
  ) async {
    try {
      final result = await getUser();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, String?>> _createUser(
    _CreateUser createUser,
  ) async {
    try {
      final result = await createUser();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, String?>> _updateUser(
    _UpdateUser updateUser,
  ) async {
    try {
      final result = await updateUser();
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
