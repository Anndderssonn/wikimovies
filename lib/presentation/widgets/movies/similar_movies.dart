import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';
import 'package:wiki_movies/presentation/widgets/widgets.dart';

final similarMoviesProvider = FutureProvider.family((ref, int movieID) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getSimilarMovies(movieID);
});

class SimilarMovies extends ConsumerWidget {
  final int movieID;

  const SimilarMovies({super.key, required this.movieID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarMoviesFuture = ref.watch(similarMoviesProvider(movieID));

    return similarMoviesFuture.when(
      data: (movies) => _Suggestions(movies: movies),
      error:
          (error, stackTrace) => const Center(
            child: Text(
              'Suggestions are on vacation. Come back soon before they get too comfy on the beach. 🏖️🎬',
            ),
          ),
      loading:
          () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _Suggestions extends StatelessWidget {
  final List<Movie> movies;

  const _Suggestions({required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 50),
      child: MoviesHorizontalListview(title: 'Suggestions', movies: movies),
    );
  }
}
