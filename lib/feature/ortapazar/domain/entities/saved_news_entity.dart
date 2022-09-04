import 'package:equatable/equatable.dart';

class SavedNewsEntity extends Equatable {
  final String id;
  final String userId;
  final String newsId;

  const SavedNewsEntity({
    required this.id,
    required this.userId,
    required this.newsId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'news_id': newsId,
    };
  }

  SavedNewsEntity.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          userId: json['user_id']! as String,
          newsId: json['news_id']! as String,
        );

  @override
  List<Object?> get props => [
        id,
        userId,
        newsId,
      ];
}
