import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/infrastructure/datasources/actor_themoviedb_datasource.dart';
import 'package:wiki_movies/infrastructure/repositories/actor_repository_impl.dart';

final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl(ActorThemoviedbDatasource());
});
