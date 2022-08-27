part of 'create_news_cubit.dart';

class CreateNewsState extends Equatable {
  final File file;
  final String url;
  final String imagePath;

  const CreateNewsState({
    required this.file,
    required this.url,
    required this.imagePath,
  });

  CreateNewsState copyWith({
    File? file,
    String? url,
    String? imagePath,
  }) {
    return CreateNewsState(
      file: file ?? this.file,
      url: url ?? this.url,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object> get props => [
        file,
        url,
        imagePath,
      ];
}
