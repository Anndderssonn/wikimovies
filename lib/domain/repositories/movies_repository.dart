import 'package:wiki_movies/domain/entities/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getFilmsInTheaters({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
}
