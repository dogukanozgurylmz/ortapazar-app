import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/user/create_user.dart';

import '../../../../../core/constants/app_constant.dart';
import '../../../data/datasource/ortapazar_auth.dart';
import '../../../domain/entities/user_entity.dart';

part 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final CreateUserUseCase _createUser;
  SignInCubit({required CreateUserUseCase createUser})
      : _createUser = createUser,
        super(
          const SignInState(
            isSignIn: false,
          ),
        ) {
    init();
  }

  Future<void> init() async {
    if (OrtapazarAuth().firebaseAuth.currentUser != null) {
      emit(state.copyWith(isSignIn: true));
    }
  }

  Future<void> signInWithGoogle() async {
    await OrtapazarAuth().signInWithGoogle();
    await createUser();
    emit(state.copyWith(isSignIn: true));
  }

  Future<void> signInWithFacebook() async {
    await OrtapazarAuth().signInWithFacebook();
    await createUser();
    emit(state.copyWith(isSignIn: true));
  }

  Future<void> createUser() async {
    var currentUser = OrtapazarAuth().firebaseAuth.currentUser;
    UserEntity newsEntity = UserEntity(
      id: currentUser!.uid,
      displayName: currentUser.displayName ?? "",
      email: currentUser.email ?? "",
      phoneNumber: currentUser.phoneNumber ?? "",
      photoUrl: currentUser.photoURL ?? "",
      emailVerified: currentUser.emailVerified,
    );
    final result = await _createUser.call(CreateUserParams(
      collectionId: AppConstant.USER_COLLECTION_ID,
      documentId: currentUser.uid,
      data: newsEntity.toJson(),
    ));
    final either = result.fold((l) => l, (r) => r);
    if (either is String) {
    } else {
      return;
    }
  }
}
