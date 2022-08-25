part of 'favorite_cubit.dart';

class FavoriteState extends Equatable {
  final List<NewsEntity> news;
  final List<SavedNewsEntity> savedNews;
  final bool isLoading;

  const FavoriteState({
    required this.news,
    required this.savedNews,
    required this.isLoading,
  });

  FavoriteState copyWith({
    List<NewsEntity>? news,
    List<SavedNewsEntity>? savedNews,
    bool? isLoading,
  }) {
    return FavoriteState(
      news: news ?? this.news,
      savedNews: savedNews ?? this.savedNews,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [
        news,
        savedNews,
        isLoading,
      ];
}
