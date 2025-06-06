import 'package:dio/dio.dart';
import 'package:wiki_movies/config/constants/environments.dart';
import 'package:wiki_movies/domain/datasources/movies_datasource.dart';
import 'package:wiki_movies/domain/entities/entities.dart';
import 'package:wiki_movies/infrastructure/mappers/mappers.dart';
import 'package:wiki_movies/infrastructure/models/models.dart';

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

  @override
  Future<Movie> getMovieByID(String id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200) {
      throw Exception('Movie with ID: $id not found.');
    }
    final movieDBDetail = MovieDetail.fromJson(response.data);
    final Movie movie = MovieMapper.theMovieDBDetailToEntity(movieDBDetail);
    return movie;
  }

  @override
  Future<List<Movie>> searchMovie(String query) async {
    if (query.isEmpty) return [];
    final response = await dio.get(
      '/search/movie',
      queryParameters: {'query': query},
    );
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieID) async {
    final response = await dio.get('/movie/$movieID/similar');
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Video>> getYoutubeVideosByID(int movieID) async {
    final resposne = await dio.get('/movie/$movieID/videos');
    final theMovieDBVideosResponse = MoviedbVideosResponse.fromJson(
      resposne.data,
    );
    final videos = <Video>[];
    for (var theMovieDBVideo in theMovieDBVideosResponse.results) {
      if (theMovieDBVideo.site == 'YouTube') {
        final video = VideoMapper.theMovieDBVideoToEntity(theMovieDBVideo);
        videos.add(video);
      }
    }
    return videos;
  }
}
