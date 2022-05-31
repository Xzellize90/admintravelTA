import 'package:dio/dio.dart';
import 'package:travel_admin/data/repo/content_repo.dart';
import 'package:travel_admin/data/repo/favorit_repo.dart';
import 'package:travel_admin/data/repo/kategori_repo.dart';
import 'package:travel_admin/data/repo/language_repo.dart';
import 'package:travel_admin/data/repo/lokasi_repo.dart';
import 'package:travel_admin/provider/Kategori_provider.dart';
import 'package:travel_admin/provider/auth_provider.dart';
import 'package:travel_admin/provider/content_provider.dart';
import 'package:travel_admin/provider/favorit_provider.dart';
import 'package:travel_admin/provider/language_provider.dart';
import 'package:travel_admin/provider/localization_provider.dart';
import 'package:travel_admin/provider/lokasi_provider.dart';
import 'package:travel_admin/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'data/repo/auth_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());

  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => ContentRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => KategoriRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => LokasiRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => FavoritRepo(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => ContentProvider(contentRepo: sl()));
  sl.registerFactory(() => KategoriProvider(kategoriRepo: sl()));
  sl.registerFactory(() => LokasiProvider(lokasiRepo: sl()));
  sl.registerFactory(() => FavoritProvider(favoritRepo: sl()));
}
