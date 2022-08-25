// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String image;
  final String addedDate;
  final bool isSaved;

  const NewsEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.addedDate,
    required this.isSaved,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'image': image,
      'added_date': addedDate,
      'is_saved': isSaved,
    };
  }

  NewsEntity.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          title: json['title']! as String,
          content: json['content']! as String,
          image: json['image']! as String,
          addedDate: json['added_date']! as String,
          isSaved: json['is_saved'] as bool,
        );

  @override
  List<Object?> get props => [id, title, content, image, addedDate, isSaved];
}
