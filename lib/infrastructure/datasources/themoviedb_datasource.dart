import 'package:dio/dio.dart';
import 'package:wiki_movies/config/constants/environments.dart';
import 'package:wiki_movies/domain/datasources/movies_datasource.dart';
import 'package:wiki_movies/domain/entities/movie.dart';

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
    final response = dio.get('/movie/now_playing');
    final List<Movie> movies = [];
    return movies;
  }
}
