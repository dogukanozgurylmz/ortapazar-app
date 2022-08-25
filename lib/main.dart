import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/news_datasource.dart';
import 'package:ortapazar/feature/ortapazar/data/repository/news_repository_impl.dart';
import 'package:ortapazar/feature/ortapazar/domain/repositories/news_repository.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/news/create_news.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/news/get_news_list.dart';
import 'package:ortapazar/feature/ortapazar/presentation/base_page/base_view.dart';
import 'package:ortapazar/feature/ortapazar/presentation/create_news/cubit/create_news_cubit.dart';
import 'package:ortapazar/feature/ortapazar/presentation/favorite/cubit/favorite_cubit.dart';
import 'package:ortapazar/feature/ortapazar/presentation/home/cubit/home_cubit.dart';

import 'feature/ortapazar/data/datasource/saved_news_datasource.dart';
import 'feature/ortapazar/data/repository/saved_news_repository_impl.dart';
import 'feature/ortapazar/domain/repositories/saved_news_repository.dart';
import 'feature/ortapazar/domain/usecases/news/update_news.dart';
import 'feature/ortapazar/domain/usecases/saved_news/create_saved_news.dart';
import 'feature/ortapazar/domain/usecases/saved_news/delete_saved_news.dart';
import 'feature/ortapazar/domain/usecases/saved_news/get_saved_news_list.dart';
import 'feature/ortapazar/domain/usecases/saved_news/update_saved_news.dart';
import 'firebase_options.dart';

GetIt getIt = GetIt.instance;
void main() async {
  getIt.registerFactory(() => HomeCubit(
        getNewsList: getIt(),
        createSavedNews: getIt(),
        getSavedNewsList: getIt(),
        deleteSavedNews: getIt(),
      ));
  getIt.registerFactory(() => FavoriteCubit(
        getNewsList: getIt(),
        getSavedNewsList: getIt(),
        deleteSavedNews: getIt(),
      ));

  getIt.registerFactory(() => CreateNewsCubit(getIt()));

  getIt
      .registerLazySingleton(() => GetNewsListUseCase(newsRepository: getIt()));
  getIt.registerLazySingleton(() => CreateNewsUseCase(newsRepository: getIt()));
  getIt.registerLazySingleton(() => UpdateNewsUseCase(newsRepository: getIt()));

  getIt.registerLazySingleton(
      () => GetSavedNewsListUseCase(savedNewsRepository: getIt()));
  getIt.registerLazySingleton(
      () => CreateSavedNewsUseCase(savedNewsRepository: getIt()));
  getIt.registerLazySingleton(
      () => UpdateSavedNewsUseCase(savedNewsRepository: getIt()));
  getIt.registerLazySingleton(
      () => DeleteSavedNewsUseCase(savedNewsRepository: getIt()));

  getIt
      .registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<NewsDataSource>(() => NewsDataSourceImpl());

  getIt.registerLazySingleton<SavedNewsRepository>(
      () => SavedNewsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<SavedNewsDataSource>(
      () => SavedNewsDataSourceImpl());

  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const OrtapazarApp());
}

class OrtapazarApp extends StatelessWidget {
  const OrtapazarApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'RobotoCondensed',
      ),
      home: const BaseView(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
