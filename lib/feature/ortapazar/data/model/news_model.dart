import 'package:equatable/equatable.dart';

class NewsModel extends Equatable {
  final String id;
  final String currentUser;
  final String title;
  final String content;
  final String image;
  final String addedDate;
  final bool isSaved;

  const NewsModel({
    required this.id,
    required this.currentUser,
    required this.title,
    required this.content,
    required this.image,
    required this.addedDate,
    required this.isSaved,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'current_user': currentUser,
      'title': title,
      'content': content,
      'image': image,
      'added_date': addedDate,
      'is_saved': isSaved,
    };
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id']! as String,
      currentUser:
          json['current_user'] != null ? json['current_user'] as String : '',
      title: json['title']! as String,
      content: json['content']! as String,
      image: json['image']! as String,
      addedDate: json['added_date']! as String,
      isSaved: json['is_saved'] as bool,
    );
  }

  @override
  List<Object?> get props => [
        id,
        currentUser,
        title,
        content,
        image,
        addedDate,
        isSaved,
      ];
}
