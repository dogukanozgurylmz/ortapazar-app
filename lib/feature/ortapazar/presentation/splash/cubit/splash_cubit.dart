import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../../firebase_options.dart';

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
    emit(state.copyWith(isFirebaseInitialize: false));
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    await Firebase.initializeApp();
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(state.copyWith(isFirebaseInitialize: true));
  }
}
