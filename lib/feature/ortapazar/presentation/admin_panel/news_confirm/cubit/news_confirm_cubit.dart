import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/news/update_news.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/user/get_users.dart';

import '../../../../../../core/constants/app_constant.dart';
import '../../../../domain/entities/news_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/news/get_news_list.dart';

part 'news_confirm_state.dart';

class NewsConfirmCubit extends Cubit<NewsConfirmState> {
  final List<NewsEntity> _newsList = [];
  final GetNewsListUseCase _getNewsList;
  final GetUsersUseCase _getUsers;
  final UpdateNewsUseCase _updateNews;
  String url = "";

  NewsConfirmCubit({
    required GetNewsListUseCase getNewsList,
    required GetUsersUseCase getUsers,
    required UpdateNewsUseCase updateNews,
  })  : _getNewsList = getNewsList,
        _getUsers = getUsers,
        _updateNews = updateNews,
        super(const NewsConfirmState(
          isLoading: false,
          isConfirm: false,
          message: "",
          news: [],
          users: [],
        )) {
    init();
  }

  Future<void> init() async {
    await getUsers();
    await getNews();
  }

  Future<void> getNews() async {
    _newsList.clear();
    emit(state.copyWith(news: [], isLoading: true));
    try {
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
          newsList.add(element);
        }
        await downloadImage(newsList);
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(
          isLoading: false,
          message: 'Haber yok',
        ));
        return;
      }
    } on Exception {
      log("hadtadsada");
    }
  }

  Future<void> downloadImage(List<NewsEntity> newsEntities) async {
    try {
      for (var newsEntity in newsEntities) {
        var documentSnapshot = await FirebaseFirestore.instance
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
      _newsList.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
      emit(state.copyWith(
        news: _newsList,
      ));
    } on Exception {
      log("Hataaa");
    }
  }

  Future<void> getUsers() async {
    emit(state.copyWith(users: []));
    List<UserEntity> users = [];
    final result = await _getUsers.call(GetUsersParams(
      collectionId: AppConstant.USER_COLLECTION_ID,
      limit: 100,
    ));

    final either = result.fold((l) => l, (r) => r);
    if (either is List<UserEntity>) {
      users.addAll(either);
      emit(state.copyWith(users: users));
    }
  }

  String userControl(String userId) {
    var firstWhere = state.users.firstWhere((e) => e.id == userId);
    return firstWhere.displayName;
  }

  Future<void> changeIsConfirm(
    bool value,
    NewsEntity newsEntity,
  ) async {
    emit(state.copyWith(isConfirm: true));
    NewsEntity entity = NewsEntity(
      id: newsEntity.id,
      userId: newsEntity.userId,
      title: newsEntity.title,
      content: newsEntity.content,
      image: "newsImage/${newsEntity.id}53.jpg",
      addedDate: newsEntity.addedDate,
      isConfirm: value,
      createdAt: newsEntity.createdAt,
    );
    final result = await _updateNews.call(UpdateNewsParams(
      collectionId: AppConstant.NEWS_COLLECTIN_ID,
      documentId: newsEntity.id,
      data: entity.toJson(),
    ));
    final either = result.fold((l) => l, (r) => r);
    if (either is String) {
      await getNews();
    }
    emit(state.copyWith(isConfirm: false));
  }
}
