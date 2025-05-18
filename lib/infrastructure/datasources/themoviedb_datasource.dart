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

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final theMovieDBResponse = TheMovieDBResponse.fromJson(json);
    final List<Movie> movies =
        theMovieDBResponse.results
            .where((theMovieDB) => theMovieDB.posterPath != 'no-poster')
            .map((theMovieDB) => MovieMapper.theMovieDBToEntity(theMovieDB))
            .toList();
    return movies;
  }

  @override
  Future<List<Movie>> getFilmsInTheaters({int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {'page': page},
    );
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get(
      '/movie/popular',
      queryParameters: {'page': page},
    );
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      '/movie/top_rated',
      queryParameters: {'page': page},
    );
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get(
      '/movie/upcoming',
      queryParameters: {'page': page},
    );
    return _jsonToMovies(response.data);
  }
}
