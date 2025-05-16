import 'package:wiki_movies/domain/entities/movie.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getFilmsInTheaters({int page = 1});
}
