import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:wiki_movies/config/helpers/human_format.dart';
import 'package:wiki_movies/domain/entities/movie.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovie;
  List<Movie> initialMovies;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({required this.searchMovie, required this.initialMovies});

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovie(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  void _clearStreams() {
    debouncedMovies.close();
    isLoadingStream.close();
  }

  Widget _buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _SearchMovieItem(
              movie: movies[index],
              onMovieSelected: (context, movie) {
                _clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }

  @override
  String? get searchFieldLabel => 'Search Film...';

  @override
  TextStyle? get searchFieldStyle => TextStyle(
    color: Colors.red[300],
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: Icon(Icons.refresh_rounded, color: colors.primary),
              ),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '',
              icon: Icon(Icons.clear, color: colors.primary),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: () {
        _clearStreams();
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.primary),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return _buildResultsAndSuggestions();
  }
}

class _SearchMovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _SearchMovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  height: 130,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage(
                    'assets/loaders/bottle-loader.gif',
                  ),
                  image: NetworkImage(movie.posterPath),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.bodyLarge),
                  Text(
                    movie.overview,
                    maxLines: 3,
                    style: textStyle.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_outlined,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        HumanFormat.number(movie.voteAverage, 1),
                        style: textStyle.bodyMedium?.copyWith(
                          color: Colors.yellow.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
