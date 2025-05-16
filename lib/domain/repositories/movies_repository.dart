import 'package:wiki_movies/domain/entities/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getFilmsInTheaters({int page = 1});
}
