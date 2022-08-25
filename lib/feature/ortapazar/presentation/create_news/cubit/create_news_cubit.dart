import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:image_picker/image_picker.dart';
import 'package:ortapazar/core/constants/app_constant.dart';
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
  File? _image;

  CreateNewsCubit(
    CreateNewsUseCase createNews,
  )   : _createNews = createNews,
        super(
          CreateNewsState(
            file: File(""),
            url: '',
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
      title: newsTitleController.text,
      content: newsContentController.text,
      image: state.url,
      addedDate: _newsAddedDate,
      isSaved: false,
    );
    final result = await _createNews.call(CreateNewsParams(
      collectionId: "news",
      documentId: newDocId,
      data: newsEntity.toJson(),
    ));
    final either = result.fold((l) => l, (r) => r);
    if (either is List<NewsEntity>) {
      emit(state.copyWith());
    } else {
      return;
    }
  }

  Future<void> getImage(ImageSource source) async {
    _image = (await ImagePicker.platform.pickImage(
      source: source,
    )) as File;
    if (_image == null) return;
    emit(state.copyWith(file: _image));
  }

  Future<void> addImageToFirebase(String newDocId) async {
    Reference ref = storageReference.child("newsImage");
    ref.child("${newDocId}53.jpg").putFile(state.file);

    final String url = await ref.getDownloadURL();
    emit(state.copyWith(url: url));
  }

  // Future<void> getImage(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker.platform.pickImage(source: source);

  //     final imageTemporary = File(image.path);
  //     emit(state.copyWith(file: imageTemporary));
  //     isUploaded = true;
  //   } on PlatformException {
  //     isUploaded = false;
  //   }
  // }

  /////////////////////////////////////////////////////////////////////////////////////

}
