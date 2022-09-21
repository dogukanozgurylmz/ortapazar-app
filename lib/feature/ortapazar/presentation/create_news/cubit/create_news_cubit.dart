import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show DateFormat;
import 'package:image_picker/image_picker.dart';
import 'package:ortapazar/core/constants/app_constant.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/ortapazar_database.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/news_entity.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/news/create_news.dart';

part 'create_news_state.dart';

class CreateNewsCubit extends Cubit<CreateNewsState> {
  TextEditingController newsTitleController = TextEditingController();
  TextEditingController newsContentController = TextEditingController();
  final CreateNewsUseCase _createNews;
  final _newsAddedDate = DateFormat.yMd().format(DateTime.now());
  final storageReferance = FirebaseStorage.instance.ref();
  bool isUploaded = false;
  Reference storageReference = FirebaseStorage.instance.ref();
  File? file;
  String fullPath = "";

  CreateNewsCubit(
    CreateNewsUseCase createNews,
  )   : _createNews = createNews,
        super(
          CreateNewsState(
            file: File(""),
            url: '',
            imagePath: '',
          ),
        ) {
    init();
  }

  void init() {}

  Future<void> addNews() async {
    var newDocId = FirebaseFirestore.instance.collection('news').doc().id;

    await addImageToFirebase(newDocId);
    NewsEntity newsEntity = NewsEntity(
      id: newDocId,
      userId: FirebaseAuth.instance.currentUser!.uid,
      title: newsTitleController.text,
      content: newsContentController.text,
      image: fullPath,
      addedDate: _newsAddedDate,
      isConfirm: false,
      createdAt: Timestamp.now(),
    );
    final result = await _createNews.call(CreateNewsParams(
      collectionId: AppConstant.NEWS_COLLECTIN_ID,
      documentId: newDocId,
      data: newsEntity.toJson(),
    ));
    final either = result.fold((l) => l, (r) => r);
    if (either is String) {
      newsTitleController.clear();
      newsContentController.clear();
      emit(state.copyWith(file: file));
    } else {
      newsTitleController.clear();
      newsContentController.clear();
      return;
    }
  }

  Future<void> getImage(ImageSource source) async {
    PickedFile? image = await ImagePicker.platform.pickImage(source: source);
    if (image == null) return;
    file = File(image.path);
    emit(state.copyWith(file: file));
  }

  Future<void> addImageToFirebase(String newsId) async {
    final imagePath = state.file.path;
    final picRef =
        FirebaseStorage.instance.ref('newsImage').child('${newsId}53.jpg');
    fullPath = picRef.fullPath;
    await picRef.putFile(File(imagePath));
    emit(state.copyWith(
      imagePath: imagePath,
    ));
  }
}
