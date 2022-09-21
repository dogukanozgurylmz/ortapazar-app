import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/news_datasource.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/user_datasource.dart';
import 'package:ortapazar/feature/ortapazar/data/repository/news_repository_impl.dart';
import 'package:ortapazar/feature/ortapazar/data/repository/user_repository_impl.dart';
import 'package:ortapazar/feature/ortapazar/domain/repositories/news_repository.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/news/create_news.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/news/get_news_by_uid.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/news/get_news_list.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/news/get_news_by_createdat.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/user/create_user.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/user/get_users.dart';
import 'package:ortapazar/feature/ortapazar/domain/usecases/user/update_user.dart';
import 'package:ortapazar/feature/ortapazar/presentation/admin_panel/news_confirm/cubit/news_confirm_cubit.dart';
import 'package:ortapazar/feature/ortapazar/presentation/create_news/cubit/create_news_cubit.dart';
import 'package:ortapazar/feature/ortapazar/presentation/favorite/cubit/favorite_cubit.dart';
import 'package:ortapazar/feature/ortapazar/presentation/home/cubit/home_cubit.dart';
import 'package:ortapazar/feature/ortapazar/presentation/my_news/cubit/my_news_cubit.dart';
import 'package:ortapazar/feature/ortapazar/presentation/profile/cubit/profile_cubit.dart';
import 'package:ortapazar/feature/ortapazar/presentation/signin/cubit/signin_cubit.dart';
import 'package:ortapazar/feature/ortapazar/presentation/splash/cubit/splash_cubit.dart';
import 'package:ortapazar/feature/ortapazar/presentation/splash/splash_view.dart';

import 'feature/ortapazar/data/datasource/saved_news_datasource.dart';
import 'feature/ortapazar/data/repository/saved_news_repository_impl.dart';
import 'feature/ortapazar/domain/repositories/saved_news_repository.dart';
import 'feature/ortapazar/domain/repositories/user_repository.dart';
import 'feature/ortapazar/domain/usecases/news/update_news.dart';
import 'feature/ortapazar/domain/usecases/saved_news/create_saved_news.dart';
import 'feature/ortapazar/domain/usecases/saved_news/delete_saved_news.dart';
import 'feature/ortapazar/domain/usecases/saved_news/get_saved_news_list.dart';
import 'feature/ortapazar/domain/usecases/saved_news/update_saved_news.dart';
import 'feature/ortapazar/domain/usecases/user/get_user.dart';
import 'firebase_options.dart';

GetIt getIt = GetIt.instance;
void main() async {
  getIt.registerFactory(() => HomeCubit(
        createSavedNews: getIt(),
        getSavedNewsList: getIt(),
        deleteSavedNews: getIt(),
        getUsers: getIt(),
        getNewsOrderByCreatedAt: getIt(),
      ));
  getIt.registerFactory(() => FavoriteCubit(
        getNewsList: getIt(),
        getSavedNewsList: getIt(),
        deleteSavedNews: getIt(),
        getNewsByCreatedAt: getIt(),
      ));
  getIt.registerFactory(() => MyNewsCubit(
        getNewsById: getIt(),
      ));
  getIt.registerFactory(() => SplashCubit());
  getIt.registerFactory(() => SignInCubit(createUser: getIt()));
  getIt.registerFactory(() => ProfileCubit(
        getUser: getIt(),
      ));
  getIt.registerFactory(() => NewsConfirmCubit(
        getNewsList: getIt(),
        getUsers: getIt(),
        updateNews: getIt(),
      ));

  getIt.registerFactory(() => CreateNewsCubit(getIt()));

  getIt
      .registerLazySingleton(() => GetNewsListUseCase(newsRepository: getIt()));
  getIt.registerLazySingleton(
      () => GetNewsByCreatedAtUseCase(newsRepository: getIt()));
  getIt.registerLazySingleton(
      () => GetNewsByUIdUseCase(newsRepository: getIt()));
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

  getIt.registerLazySingleton(() => GetUsersUseCase(userRepository: getIt()));
  getIt.registerLazySingleton(() => GetUserUseCase(userRepository: getIt()));
  getIt.registerLazySingleton(() => CreateUserUseCase(userRepository: getIt()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(userRepository: getIt()));

  getIt
      .registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<NewsDataSource>(() => NewsDataSourceImpl());

  getIt.registerLazySingleton<SavedNewsRepository>(
      () => SavedNewsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<SavedNewsDataSource>(
      () => SavedNewsDataSourceImpl());

  getIt
      .registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt()));
  getIt.registerLazySingleton<UserDataSource>(() => UserDataSourceImpl());

  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const OrtapazarApp());
}

class OrtapazarApp extends StatelessWidget {
  const OrtapazarApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      title: 'Ortapazar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'RobotoCondensed',
      ),
      home: const SplashView(),
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
