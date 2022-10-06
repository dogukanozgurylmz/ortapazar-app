part of 'create_news_cubit.dart';

class CreateNewsState extends Equatable {
  final File file;
  final String url;
  final String imagePath;
  final bool isLoading;
  final bool isLoadAd;

  const CreateNewsState({
    required this.file,
    required this.url,
    required this.imagePath,
    required this.isLoading,
    required this.isLoadAd,
  });

  CreateNewsState copyWith({
    File? file,
    String? url,
    String? imagePath,
    bool? isLoading,
    bool? isLoadAd,
  }) {
    return CreateNewsState(
      file: file ?? this.file,
      url: url ?? this.url,
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      isLoadAd: isLoadAd ?? this.isLoadAd,
    );
  }

  @override
  List<Object> get props => [
        file,
        url,
        imagePath,
        isLoading,
        isLoadAd,
      ];
}
