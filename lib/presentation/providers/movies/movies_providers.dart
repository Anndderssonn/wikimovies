import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';

final filmsInTheatersProvider =
    StateNotifierProvider<MoviesNotifierController, List<Movie>>((ref) {
      final fetchMoreMovies =
          ref.watch(movieRepositoryProvider).getFilmsInTheaters;
      return MoviesNotifierController(fetchMoreMovies: fetchMoreMovies);
    });

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifierController extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  MovieCallback fetchMoreMovies;

  MoviesNotifierController({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
  }
}
