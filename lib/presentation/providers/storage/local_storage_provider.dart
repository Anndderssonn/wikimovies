import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/infrastructure/datasources/isar_datasource.dart';
import 'package:wiki_movies/infrastructure/repositories/local_storage_repository_impl.dart';

final localStorageProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(IsarDatasource());
});
