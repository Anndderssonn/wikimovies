import 'package:dio/dio.dart';
import 'package:wiki_movies/config/constants/environments.dart';
import 'package:wiki_movies/domain/datasources/movies_datasource.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/infrastructure/mappers/themoviedb/movie_mapper.dart';
import 'package:wiki_movies/infrastructure/models/themoviedb/themoviedb_response.dart';

class TheMovieDBDatasource extends MoviesDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environments.theMovieDBKey,
        'language': 'en-US',
      },
    ),
  );

  @override
  Future<List<Movie>> getFilmsInTheaters({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');
    final theMovieDBResponse = TheMovieDBResponse.fromJson(response.data);
    final List<Movie> movies =
        theMovieDBResponse.results
            .where((theMovieDB) => theMovieDB.posterPath != 'no-poster')
            .map((theMovieDB) => MovieMapper.theMovieDBToEntity(theMovieDB))
            .toList();
    return movies;
  }
}
