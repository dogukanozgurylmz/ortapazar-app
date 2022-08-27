import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ortapazar/core/constants/app_constant.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/news_entity.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/news/get_news_list.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/saved_news/create_saved_news.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/saved_news/delete_saved_news.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/saved_news/get_saved_news_list.dart';

import '../../../domain/entities/saved_news_entity.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  List<NewsEntity> _newsList = [];
  List<SavedNewsEntity> _savedNewsList = [];
  final GetNewsListUseCase _getNewsList;
  final GetSavedNewsListUseCase _getSavedNewsList;
  final CreateSavedNewsUseCase _createSavedNews;
  final DeleteSavedNewsUseCase _deleteSavedNews;
  String url = "";

  HomeCubit({
    required GetNewsListUseCase getNewsList,
    required GetSavedNewsListUseCase getSavedNewsList,
    required CreateSavedNewsUseCase createSavedNews,
    required DeleteSavedNewsUseCase deleteSavedNews,
  })  : _getNewsList = getNewsList,
        _getSavedNewsList = getSavedNewsList,
        _createSavedNews = createSavedNews,
        _deleteSavedNews = deleteSavedNews,
        super(
          const HomeState(
            news: [],
            savedNews: [],
            isLoading: false,
            isSavedNews: false,
          ),
        ) {
    init();
  }

  Future<void> init() async {
    await getNews();
    await getSavedNews();
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: !state.isLoading));
    await init();
    emit(state.copyWith(isLoading: !state.isLoading));
  }

  Future<void> getNews() async {
    emit(state.copyWith(isLoading: true));
    final List<NewsEntity> newsList = [];
    final result = await _getNewsList.call(
      GetNewsListParams(
        collectionId: AppConstant.NEWS_COLLECTIN_ID,
        limit: 100,
      ),
    );
    final either = result.fold((l) => l, (r) => r);
    if (either is List<NewsEntity>) {
      newsList.addAll(either);
      await downloadImage(newsList);
      // _newsList = newsList;
      // emit(state.copyWith(news: _newsList));
    } else {
      return;
    }
  }

  Future<void> downloadImage(List<NewsEntity> newsEntities) async {
    for (var newsEntity in newsEntities) {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('news')
          .doc(newsEntity.id)
          .get();
      var data = documentSnapshot.data();
      if (data == null) return;
      if (data.containsKey('image')) {
        url =
            await FirebaseStorage.instance.ref(data['image']).getDownloadURL();
        NewsEntity entity = NewsEntity(
            id: newsEntity.id,
            title: newsEntity.title,
            content: newsEntity.content,
            image: url,
            addedDate: newsEntity.addedDate,
            isSaved: newsEntity.isSaved);
        _newsList.add(entity);
      }
    }
    emit(state.copyWith(
      isLoading: false,
      news: _newsList,
    ));
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

    if (savedNews.isEmpty) {
      var savedNewsDocId =
          FirebaseFirestore.instance.collection('saved_news').doc().id;
      SavedNewsEntity savedNewsEntity = SavedNewsEntity(
        id: savedNewsDocId,
        newsId: state.news[index].id,
      );
      final result = await _createSavedNews.call(CreateSavedNewsParams(
        collectionId: AppConstant.SAVED_NEWS_COLLECTION_ID,
        documentId: savedNewsDocId,
        data: savedNewsEntity.toJson(),
      ));
      final either = result.fold((l) => l, (r) => r);
      if (either is String) {
        await getSavedNews();
      } else {
        return;
      }
    } else {
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
}
