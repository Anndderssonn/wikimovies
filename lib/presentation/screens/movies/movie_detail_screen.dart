import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  static const name = 'movie-detail-screen';

  final String movieID;

  const MovieDetailScreen({super.key, required this.movieID});

  @override
  MovieDetailScreenState createState() => MovieDetailScreenState();
}

class MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieDetailProvider.notifier).loadMovie(widget.movieID);
    ref.read(actorsByMovieProvider.notifier).loadActorsByMovie(widget.movieID);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieDetailProvider)[widget.movieID];

    if (movie == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetail(movie: movie),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieDetail extends StatelessWidget {
  final Movie movie;

  const _MovieDetail({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(movie.posterPath, width: size.width * 0.3),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  children: [
                    Text(movie.title, style: textStyle.titleLarge),
                    Text(movie.overview, style: textStyle.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map(
                (genre) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    backgroundColor: colors.surfaceContainer,
                    label: Text(genre),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _MovieCast(movieID: movie.id.toString()),
        const SizedBox(height: 50),
      ],
    );
  }
}

final isFavoriteProvider = FutureProvider.family.autoDispose((
  ref,
  int movieID,
) {
  final localStorageRepository = ref.watch(localStorageProvider);
  return localStorageRepository.isMovieFavorite(movieID);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    return SliverAppBar(
      backgroundColor: colors.inversePrimary,
      expandedHeight: size.height * 0.7,
      foregroundColor: colors.inversePrimary,
      actions: [
        IconButton(
          onPressed: () {
            ref.watch(localStorageProvider).toggleFavorite(movie);
            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
            data:
                (isFavorite) =>
                    isFavorite
                        ? Icon(Icons.favorite_rounded)
                        : Icon(Icons.favorite_border),
            error: (error, stackTrace) => throw UnimplementedError(),
            loading: () => const CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),
            const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.3],
              colors: [Colors.black87, Colors.transparent],
            ),
            const _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.85, 1.0],
              colors: [Colors.transparent, Colors.black87],
            ),
            const _CustomGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              stops: [0.0, 0.5],
              colors: [Colors.black87, Colors.transparent],
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieCast extends ConsumerWidget {
  final String movieID;

  const _MovieCast({required this.movieID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme;
    final actorsByMovie = ref.watch(actorsByMovieProvider)[movieID];

    if (actorsByMovie == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actorsByMovie.length,
        itemBuilder: (context, index) {
          final actor = actorsByMovie[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    actor.profilePath,
                    height: 180,
                    width: 135,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                Text(actor.name, maxLines: 2),
                Text(
                  actor.character ?? 'Unknown',
                  maxLines: 2,
                  style: textStyle.labelMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    required this.begin,
    required this.end,
    required this.stops,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
