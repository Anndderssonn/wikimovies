import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/infrastructure/datasources/themoviedb_datasource.dart';
import 'package:wiki_movies/infrastructure/repositories/movies_repository_impl.dart';

final movieRepositoryProvider = Provider((ref) {
  return MoviesRepositoryImpl(TheMovieDBDatasource());
});
