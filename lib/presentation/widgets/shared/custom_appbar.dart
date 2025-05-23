import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/presentation/delegates/search_movie_delegate.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary),
              const SizedBox(width: 5),
              Text('WikiFilms', style: titleStyle),
              const Spacer(),
              IconButton(
                onPressed: () {
                  final moviesSearched = ref.read(moviesSearchedProvider);
                  final searchQuery = ref.read(searchQueryProvider);
                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                      searchMovie:
                          ref
                              .read(moviesSearchedProvider.notifier)
                              .moviesSearchedByQuery,
                      initialMovies: moviesSearched,
                    ),
                  ).then((movie) {
                    if (movie == null || !context.mounted) return;
                    context.push('/movie/${movie.id}');
                  });
                },
                icon: Icon(Icons.search, color: colors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
