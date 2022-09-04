part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final UserEntity user;

  const ProfileState({
    required this.user,
  });

  ProfileState copyWith({final UserEntity? user}) {
    return ProfileState(
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [
        user,
      ];
}
