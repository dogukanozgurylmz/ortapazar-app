import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ortapazar/core/constants/app_constant.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/ortapazar_auth.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/user_entity.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/user/get_users.dart';

import '../../../domain/usecases/user/get_user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserUseCase _getUser;

  ProfileCubit({required GetUserUseCase getUser})
      : _getUser = getUser,
        super(
          const ProfileState(
            user: UserEntity(
              id: "",
              displayName: "",
              email: "",
              phoneNumber: "",
              photoUrl: "",
              emailVerified: false,
            ),
          ),
        ) {
    init();
  }

  Future<void> init() async {
    await getUser();
  }

  Future<void> getUser() async {
    final result = await _getUser.call(GetUserParams(
        collectionId: AppConstant.USER_COLLECTION_ID,
        documentId: OrtapazarAuth().firebaseAuth.currentUser!.uid));

    final either = result.fold((l) => l, (r) => r);
    if (either is UserEntity) {
      log("get user");
      emit(state.copyWith(user: either));
    }
  }
}
