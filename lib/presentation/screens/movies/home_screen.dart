import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';
import 'package:wiki_movies/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(filmsInTheatersProvider.notifier).loadNextPage();
    ref.read(upcomingFilmsProvider.notifier).loadNextPage();
    ref.read(popularFilmsProvider.notifier).loadNextPage();
    ref.read(topRatedFilmsProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();
    final slideShowFilms = ref.watch(moviesSlideshowProvider);
    final filmsInTheaters = ref.watch(filmsInTheatersProvider);
    final upcomingFilms = ref.watch(upcomingFilmsProvider);
    final popularFilms = ref.watch(popularFilmsProvider);
    final topRatedFilms = ref.watch(topRatedFilmsProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                MoviesSlideshow(movies: slideShowFilms),
                MoviesHorizontalListview(
                  movies: filmsInTheaters,
                  title: 'In Theaters',
                  subTitle: 'Friday 20th',
                  loadNextPage: () {
                    ref.read(filmsInTheatersProvider.notifier).loadNextPage();
                  },
                ),
                MoviesHorizontalListview(
                  movies: upcomingFilms,
                  title: 'Coming Soon',
                  subTitle: 'This month',
                  loadNextPage: () {
                    ref.read(upcomingFilmsProvider.notifier).loadNextPage();
                  },
                ),
                MoviesHorizontalListview(
                  movies: popularFilms,
                  title: 'Always Acclaimed',
                  loadNextPage: () {
                    ref.read(popularFilmsProvider.notifier).loadNextPage();
                  },
                ),
                MoviesHorizontalListview(
                  movies: topRatedFilms,
                  title: 'Top Rated',
                  subTitle: 'Of all times',
                  loadNextPage: () {
                    ref.read(topRatedFilmsProvider.notifier).loadNextPage();
                  },
                ),
                const SizedBox(height: 10),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
