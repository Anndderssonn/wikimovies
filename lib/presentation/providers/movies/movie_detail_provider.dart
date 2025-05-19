import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/presentation/providers/movies/movies_repository_provider.dart';

final movieDetailProvider =
    StateNotifierProvider<MovieMapNotifierController, Map<String, Movie>>((
      ref,
    ) {
      final fetchMovieID = ref.watch(movieRepositoryProvider).getMovieByID;
      return MovieMapNotifierController(getMovie: fetchMovieID);
    });

typedef GetMovieCallback = Future<Movie> Function(String movieID);

class MovieMapNotifierController extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;

  MovieMapNotifierController({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieID) async {
    if (state[movieID] != null) return;
    final movie = await getMovie(movieID);
    state = {...state, movieID: movie};
  }
}
