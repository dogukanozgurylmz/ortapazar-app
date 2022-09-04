part of 'splash_cubit.dart';

class SplashState extends Equatable {
  final bool isFirebaseInitialize;

  const SplashState({
    required this.isFirebaseInitialize,
  });

  SplashState copyWith({
    bool? isFirebaseInitialize,
  }) {
    return SplashState(
      isFirebaseInitialize: isFirebaseInitialize ?? this.isFirebaseInitialize,
    );
  }

  @override
  List<Object> get props => [
        isFirebaseInitialize,
      ];
}
