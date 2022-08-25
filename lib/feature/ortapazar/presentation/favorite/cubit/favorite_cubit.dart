import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/constants/app_constant.dart';
import '../../../domain/entities/news_entity.dart';
import '../../../domain/entities/saved_news_entity.dart';
import '../../../domain/usecases/news/get_news_list.dart';
import '../../../domain/usecases/saved_news/delete_saved_news.dart';
import '../../../domain/usecases/saved_news/get_saved_news_list.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  List<NewsEntity> _newsList = [];
  List<SavedNewsEntity> _savedNewsList = [];
  final GetNewsListUseCase _getNewsList;
  final GetSavedNewsListUseCase _getSavedNewsList;
  final DeleteSavedNewsUseCase _deleteSavedNews;

  FavoriteCubit({
    required GetNewsListUseCase getNewsList,
    required GetSavedNewsListUseCase getSavedNewsList,
    required DeleteSavedNewsUseCase deleteSavedNews,
  })  : _getNewsList = getNewsList,
        _getSavedNewsList = getSavedNewsList,
        _deleteSavedNews = deleteSavedNews,
        super(
          const FavoriteState(
            news: [],
            savedNews: [],
            isLoading: false,
          ),
        ) {
    init();
  }

  Future<void> init() async {
    await getSavedNews();
    await getNews();
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: !state.isLoading));
    await init();
    emit(state.copyWith(isLoading: !state.isLoading));
  }

  Future<void> getNews() async {
    final List<NewsEntity> newsList = [];
    final result = await _getNewsList.call(
      GetNewsListParams(
        collectionId: AppConstant.NEWS_COLLECTIN_ID,
        limit: 100,
      ),
    );
    final either = result.fold((l) => l, (r) => r);
    if (either is List<NewsEntity>) {
      for (var element in either) {
        var where = state.savedNews.where((e) => e.newsId == element.id);
        if (where.isNotEmpty) {
          newsList.add(element);
        }
      }
      _newsList = newsList;
      emit(state.copyWith(news: _newsList));
    } else {
      return;
    }
  }

  Future<void> getSavedNews() async {
    final List<SavedNewsEntity> savedNewsList = [];
    final result = await _getSavedNewsList.call(
      GetSavedNewsListParams(
        collectionId: AppConstant.SAVED_NEWS_COLLECTION_ID,
        limit: 100,
      ),
    );
    final either = result.fold((l) => l, (r) => r);
    if (either is List<SavedNewsEntity>) {
      savedNewsList.addAll(either);
      _savedNewsList = savedNewsList;
      emit(state.copyWith(savedNews: _savedNewsList));
    } else {
      return;
    }
  }

  Future<void> changeSavedNews(int index) async {
    var savedNews = state.savedNews
        .where((element) => element.newsId == state.news[index].id);

    final result = await _deleteSavedNews.call(DeleteSavedNewsParams(
      collectionId: AppConstant.SAVED_NEWS_COLLECTION_ID,
      documentId: savedNews.first.id,
    ));
    final either = result.fold((l) => l, (r) => r);
    if (either is String) {
      _savedNewsList.remove(savedNews.first);
      emit(state.copyWith(savedNews: _savedNewsList));
      await getSavedNews();
    } else {
      return;
    }
  }
}
