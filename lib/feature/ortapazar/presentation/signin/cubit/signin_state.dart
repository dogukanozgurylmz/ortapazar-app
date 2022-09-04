part of 'signin_cubit.dart';

class SignInState extends Equatable {
  final bool isSignIn;

  const SignInState({
    required this.isSignIn,
  });

  SignInState copyWith({
    final bool? isSignIn,
  }) {
    return SignInState(
      isSignIn: isSignIn ?? this.isSignIn,
    );
  }

  @override
  List<Object> get props => [
        isSignIn,
      ];
}
