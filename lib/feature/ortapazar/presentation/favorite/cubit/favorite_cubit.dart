import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/ortapazar_auth.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/ortapazar_database.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/news/get_news_by_createdat.dart';

import '../../../../../core/constants/app_constant.dart';
import '../../../domain/entities/news_entity.dart';
import '../../../domain/entities/saved_news_entity.dart';
import '../../../domain/usecases/news/get_news_list.dart';
import '../../../domain/usecases/saved_news/delete_saved_news.dart';
import '../../../domain/usecases/saved_news/get_saved_news_list.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final List<NewsEntity> _newsList = [];
  List<SavedNewsEntity> _savedNewsList = [];
  final GetNewsListUseCase _getNewsList;
  final GetNewsByCreatedAtUseCase _getNewsByCreatedAt;
  final GetSavedNewsListUseCase _getSavedNewsList;
  final DeleteSavedNewsUseCase _deleteSavedNews;
  String url = "";

  FavoriteCubit({
    required GetNewsListUseCase getNewsList,
    required GetSavedNewsListUseCase getSavedNewsList,
    required DeleteSavedNewsUseCase deleteSavedNews,
    required GetNewsByCreatedAtUseCase getNewsByCreatedAt,
  })  : _getNewsList = getNewsList,
        _getSavedNewsList = getSavedNewsList,
        _deleteSavedNews = deleteSavedNews,
        _getNewsByCreatedAt = getNewsByCreatedAt,
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
    emit(state.copyWith(isLoading: true, news: []));
    _newsList.clear();
    await init();
    emit(state.copyWith(isLoading: false));
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
      for (var element in either) {
        if (OrtapazarAuth().firebaseAuth.currentUser!.uid == element.userId) {
          savedNewsList.add(element);
        }
      }
      _savedNewsList = savedNewsList;
      emit(state.copyWith(savedNews: _savedNewsList));
    } else {
      return;
    }
  }

  Future<void> getNews() async {
    emit(state.copyWith(isLoading: true));
    try {
      final List<NewsEntity> newsList = [];
      final result = await _getNewsByCreatedAt.call(
        GetNewsByCreatedAtParams(
          collectionId: AppConstant.NEWS_COLLECTIN_ID,
          query: "true",
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
        await downloadImage(newsList);
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
        return;
      }
    } on Exception {
      log("hadtadsada");
    }
  }

  Future<void> downloadImage(List<NewsEntity> newsEntities) async {
    try {
      for (var newsEntity in newsEntities) {
        var documentSnapshot = await OrtapazarDatabase()
            .firestore
            .collection('news')
            .doc(newsEntity.id)
            .get();
        var data = documentSnapshot.data();
        if (data == null) return;
        if (data.containsKey('image')) {
          url = await FirebaseStorage.instance
              .ref(data['image'])
              .getDownloadURL();
          NewsEntity entity = NewsEntity(
            id: newsEntity.id,
            userId: newsEntity.userId,
            title: newsEntity.title,
            content: newsEntity.content,
            image: url,
            addedDate: newsEntity.addedDate,
            isConfirm: newsEntity.isConfirm,
            createdAt: newsEntity.createdAt,
          );
          _newsList.add(entity);
        }
      }
    } on Exception {
      log("Hataaa");
    }
    _newsList.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    emit(state.copyWith(
      news: _newsList,
    ));
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
