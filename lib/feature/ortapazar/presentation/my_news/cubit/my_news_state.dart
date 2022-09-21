part of 'my_news_cubit.dart';

class MyNewsState extends Equatable {
  final List<NewsEntity> news;
  final List<NewsEntity> myNews;
  final bool isLoading;

  const MyNewsState({
    required this.news,
    required this.myNews,
    required this.isLoading,
  });

  MyNewsState copyWith({
    List<NewsEntity>? news,
    List<NewsEntity>? myNews,
    bool? isLoading,
  }) {
    return MyNewsState(
      news: news ?? this.news,
      myNews: myNews ?? this.myNews,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [
        news,
        myNews,
        isLoading,
      ];
}
