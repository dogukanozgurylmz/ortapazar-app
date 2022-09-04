import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit()
      : super(
          const SplashState(
            isFirebaseInitialize: false,
          ),
        ) {
    init();
  }

  Future<void> init() async {
    await initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isFirebaseInitialize: true));
  }
}
