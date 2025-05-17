import 'package:wiki_movies/domain/datasources/movies_datasource.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/domain/repositories/movies_repository.dart';

class MoviesRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource;

  MoviesRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getFilmsInTheaters({int page = 1}) {
    return datasource.getFilmsInTheaters(page: page);
  }
}
