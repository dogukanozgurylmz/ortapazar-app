import 'package:equatable/equatable.dart';

class SavedNewsEntity extends Equatable {
  final String id;
  final String newsId;

  const SavedNewsEntity({
    required this.id,
    required this.newsId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'news_id': newsId,
    };
  }

  SavedNewsEntity.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          newsId: json['news_id']! as String,
        );

  @override
  List<Object?> get props => [
        id,
        newsId,
      ];
}
