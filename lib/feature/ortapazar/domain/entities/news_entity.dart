import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String image;
  final String addedDate;
  final bool isConfirm;
  final Timestamp createdAt;

  const NewsEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.image,
    required this.addedDate,
    required this.isConfirm,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'image': image,
      'added_date': addedDate,
      'is_confirm': isConfirm,
      'created_at': createdAt,
    };
  }

  factory NewsEntity.fromJson(Map<String, dynamic> json) {
    return NewsEntity(
      id: json['id']! as String,
      userId: json['user_id'] as String,
      title: json['title']! as String,
      content: json['content']! as String,
      image: json['image']! as String,
      addedDate: json['added_date']! as String,
      isConfirm: json['is_confirm'] as bool,
      createdAt: json['created_at']! as Timestamp,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        content,
        image,
        addedDate,
        isConfirm,
        createdAt,
      ];
}
