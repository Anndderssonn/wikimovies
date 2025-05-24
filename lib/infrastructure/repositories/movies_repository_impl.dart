import 'package:wiki_movies/domain/datasources/movies_datasource.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/domain/entities/video.dart';
import 'package:wiki_movies/domain/repositories/movies_repository.dart';

class MoviesRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource;

  MoviesRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getFilmsInTheaters({int page = 1}) {
    return datasource.getFilmsInTheaters(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return datasource.getUpcoming(page: page);
  }

  @override
  Future<Movie> getMovieByID(String id) {
    return datasource.getMovieByID(id);
  }

  @override
  Future<List<Movie>> searchMovie(String query) {
    return datasource.searchMovie(query);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieID) {
    return datasource.getSimilarMovies(movieID);
  }

  @override
  Future<List<Video>> getYoutubeVideosByID(int movieID) {
    return datasource.getYoutubeVideosByID(movieID);
  }
}
