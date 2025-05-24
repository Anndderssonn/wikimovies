import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/domain/datasources/local_storage_datasource.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> ddbb;

  IsarDatasource() {
    ddbb = openDDBB();
  }

  Future<Isar> openDDBB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [MovieSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieID) async {
    final isar = await ddbb;
    final Movie? isFavoriteMovie =
        await isar.movies.filter().idEqualTo(movieID).findFirst();
    return isFavoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await ddbb;
    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await ddbb;
    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();
    if (favoriteMovie != null) {
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarID!));
      return;
    }
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }
}
