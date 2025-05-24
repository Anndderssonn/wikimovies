import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/domain/repositories/local_storage_repository.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';

final favoritesMoviesProvider =
    StateNotifierProvider<StorageMoviesNotifierController, Map<int, Movie>>((
      ref,
    ) {
      final localStorageRepository = ref.watch(localStorageProvider);
      return StorageMoviesNotifierController(
        localStorageRepository: localStorageRepository,
      );
    });

class StorageMoviesNotifierController extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifierController({required this.localStorageRepository})
    : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(
      offset: page * 10,
      limit: 20,
    );
    page++;
    final tempMoviesMap = <int, Movie>{};
    for (var movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }
    state = {...state, ...tempMoviesMap};
    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    await localStorageRepository.toggleFavorite(movie);
    final bool isMovieInFavorite = state[movie.id] != null;
    if (isMovieInFavorite) {
      state.remove(movie.id);
      state = {...state};
    } else {
      state = {...state, movie.id: movie};
    }
  }
}
