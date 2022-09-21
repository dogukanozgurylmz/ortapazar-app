import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/news/get_news_by_uid.dart';

import '../../../../../core/constants/app_constant.dart';
import '../../../data/datasource/ortapazar_auth.dart';
import '../../../data/datasource/ortapazar_database.dart';
import '../../../domain/entities/news_entity.dart';

part 'my_news_state.dart';

class MyNewsCubit extends Cubit<MyNewsState> {
  final List<NewsEntity> _myNews = [];
  final GetNewsByUIdUseCase _getNewsById;
  String url = "";

  MyNewsCubit({
    required GetNewsByUIdUseCase getNewsById,
  })  : _getNewsById = getNewsById,
        super(
          const MyNewsState(
            news: [],
            myNews: [],
            isLoading: false,
          ),
        ) {
    init();
  }

  Future<void> init() async {
    await getMyNews();
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, news: []));
    _myNews.clear();
    await init();
    emit(state.copyWith(isLoading: false));
  }

  Future<void> getMyNews() async {
    emit(state.copyWith(isLoading: true));
    final List<NewsEntity> myNews = [];
    final result = await _getNewsById.call(GetNewsByUIdParams(
      collectionId: AppConstant.NEWS_COLLECTIN_ID,
      query: OrtapazarAuth().firebaseAuth.currentUser!.uid,
    ));
    final either = result.fold((l) => l, (r) => r);
    if (either is List<NewsEntity>) {
      myNews.addAll(either);
      await downloadImage(myNews);
      emit(state.copyWith(isLoading: false));
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
          _myNews.add(entity);
        }
      }
    } on Exception {
      log("Hataaa");
    }
    _myNews.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    emit(state.copyWith(
      myNews: _myNews,
    ));
  }
}
