part of 'news_confirm_cubit.dart';

class NewsConfirmState extends Equatable {
  final List<NewsEntity> news;
  final List<UserEntity> users;
  final bool isLoading;
  final bool isConfirm;
  final String message;

  const NewsConfirmState({
    required this.news,
    required this.users,
    required this.isLoading,
    required this.isConfirm,
    required this.message,
  });

  NewsConfirmState copyWith({
    List<NewsEntity>? news,
    List<UserEntity>? users,
    bool? isLoading,
    bool? isConfirm,
    String? message,
  }) {
    return NewsConfirmState(
      news: news ?? this.news,
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      isConfirm: isConfirm ?? this.isConfirm,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        news,
        users,
        isLoading,
        isConfirm,
        message,
      ];
}
