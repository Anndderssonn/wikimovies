import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:wiki_movies/config/helpers/human_format.dart';
import 'package:wiki_movies/domain/entities/movie.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovie;

  SearchMovieDelegate({required this.searchMovie});

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
      FadeIn(
        animate: query.isNotEmpty,
        child: IconButton(
          onPressed: () => query = '',
          icon: Icon(Icons.clear, color: colors.primary),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.primary),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('results...');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchMovie(query),
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _SearchMovieItem(movie: movies[index]);
          },
        );
      },
    );
  }
}

class _SearchMovieItem extends StatelessWidget {
  final Movie movie;

  const _SearchMovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                loadingBuilder:
                    (context, child, loadingProgress) => FadeIn(child: child),
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
    );
  }
}
