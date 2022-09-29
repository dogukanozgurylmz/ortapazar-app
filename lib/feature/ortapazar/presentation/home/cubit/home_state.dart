part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<NewsEntity> news;
  final List<SavedNewsEntity> savedNews;
  final List<UserEntity> users;
  final bool isLoading;
  final bool isSavedNews;
  final bool isLoadAd;
  final String message;

  const HomeState({
    required this.news,
    required this.savedNews,
    required this.users,
    required this.isLoading,
    required this.isSavedNews,
    required this.isLoadAd,
    required this.message,
  });

  HomeState copyWith({
    List<NewsEntity>? news,
    List<SavedNewsEntity>? savedNews,
    List<UserEntity>? users,
    bool? isLoading,
    bool? isSavedNews,
    bool? isLoadAd,
    String? message,
  }) {
    return HomeState(
      news: news ?? this.news,
      savedNews: savedNews ?? this.savedNews,
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      isSavedNews: isSavedNews ?? this.isSavedNews,
      isLoadAd: isLoadAd ?? this.isLoadAd,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        news,
        savedNews,
        users,
        isLoading,
        isSavedNews,
        isLoadAd,
        message,
      ];
}
