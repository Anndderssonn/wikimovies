import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';

final filmsInTheatersProvider =
    StateNotifierProvider<MoviesNotifierController, List<Movie>>((ref) {
      final fetchMoreMovies =
          ref.watch(movieRepositoryProvider).getFilmsInTheaters;
      return MoviesNotifierController(fetchMoreMovies: fetchMoreMovies);
    });

final popularFilmsProvider =
    StateNotifierProvider<MoviesNotifierController, List<Movie>>((ref) {
      final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
      return MoviesNotifierController(fetchMoreMovies: fetchMoreMovies);
    });

final topRatedFilmsProvider =
    StateNotifierProvider<MoviesNotifierController, List<Movie>>((ref) {
      final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
      return MoviesNotifierController(fetchMoreMovies: fetchMoreMovies);
    });

final upcomingFilmsProvider =
    StateNotifierProvider<MoviesNotifierController, List<Movie>>((ref) {
      final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
      return MoviesNotifierController(fetchMoreMovies: fetchMoreMovies);
    });

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifierController extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifierController({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}
