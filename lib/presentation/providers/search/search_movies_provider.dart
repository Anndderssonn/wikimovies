import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final moviesSearchedProvider =
    StateNotifierProvider<MoviesSearchedNotifierController, List<Movie>>((ref) {
      final movieRepository = ref.read(movieRepositoryProvider).searchMovie;
      return MoviesSearchedNotifierController(
        moviesSearched: movieRepository,
        ref: ref,
      );
    });

typedef MoviesSearchedCallback = Future<List<Movie>> Function(String query);

class MoviesSearchedNotifierController extends StateNotifier<List<Movie>> {
  final MoviesSearchedCallback moviesSearched;
  final Ref ref;

  MoviesSearchedNotifierController({
    required this.moviesSearched,
    required this.ref,
  }) : super([]);

  Future<List<Movie>> moviesSearchedByQuery(String query) async {
    final List<Movie> movies = await moviesSearched(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = movies;
    return movies;
  }
}
