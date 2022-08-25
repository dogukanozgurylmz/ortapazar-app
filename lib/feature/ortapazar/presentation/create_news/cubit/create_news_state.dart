part of 'create_news_cubit.dart';

class CreateNewsState extends Equatable {
  final File file;
  final String url;

  const CreateNewsState({
    required this.file,
    required this.url,
  });

  CreateNewsState copyWith({
    File? file,
    String? url,
  }) {
    return CreateNewsState(
      file: file ?? this.file,
      url: url ?? this.url,
    );
  }

  @override
  List<Object> get props => [file, url];
}
