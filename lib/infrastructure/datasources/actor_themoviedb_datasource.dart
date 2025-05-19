import 'package:dio/dio.dart';
import 'package:wiki_movies/config/constants/environments.dart';
import 'package:wiki_movies/domain/datasources/actors_datasource.dart';
import 'package:wiki_movies/domain/entities/actor.dart';
import 'package:wiki_movies/infrastructure/mappers/themoviedb/actor_mapper.dart';
import 'package:wiki_movies/infrastructure/models/models.dart';

class ActorThemoviedbDatasource extends ActorsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environments.theMovieDBKey,
        'language': 'en-US',
      },
    ),
  );

  List<Actor> _jsonToActors(Map<String, dynamic> json) {
    final actorsTheMovieDBResponse = CreditsResponse.fromJson(json);
    final List<Actor> actors =
        actorsTheMovieDBResponse.cast
            .map(
              (castTheMovieDB) =>
                  ActorMapper.theMovieDBCastToEntity(castTheMovieDB),
            )
            .toList();
    return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieID) async {
    final response = await dio.get('/movie/$movieID/credits');
    return _jsonToActors(response.data);
  }
}
