part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<NewsEntity> news;
  final List<SavedNewsEntity> savedNews;
  final bool isLoading;
  final bool isSavedNews;

  const HomeState({
    required this.news,
    required this.savedNews,
    required this.isLoading,
    required this.isSavedNews,
  });

  HomeState copyWith({
    List<NewsEntity>? news,
    List<SavedNewsEntity>? savedNews,
    bool? isLoading,
    bool? isSavedNews,
  }) {
    return HomeState(
      news: news ?? this.news,
      savedNews: savedNews ?? this.savedNews,
      isLoading: isLoading ?? this.isLoading,
      isSavedNews: isSavedNews ?? this.isSavedNews,
    );
  }

  @override
  List<Object> get props => [
        news,
        savedNews,
        isLoading,
        isSavedNews,
      ];
}
