import 'package:wiki_movies/domain/entities/entities.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getFilmsInTheaters({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
  Future<Movie> getMovieByID(String id);
  Future<List<Movie>> searchMovie(String query);
  Future<List<Movie>> getSimilarMovies(int movieID);
  Future<List<Video>> getYoutubeVideosByID(int movieID);
}
