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
  }

  @override
  Widget build(BuildContext context) {
    final filmsInTheaters = ref.watch(filmsInTheatersProvider);
    final slideShowFilms = ref.watch(moviesSlideshowProvider);

    return Column(
      children: [
        CustomAppbar(),
        MoviesSlideshow(movies: slideShowFilms),
        MoviesHorizontalListview(
          movies: filmsInTheaters,
          title: 'In Theaters',
          subTitle: 'Friday 20th',
          loadNextPage: () {
            ref.read(filmsInTheatersProvider.notifier).loadNextPage();
          },
        ),
      ],
    );
  }
}
