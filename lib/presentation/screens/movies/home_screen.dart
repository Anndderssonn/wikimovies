import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _HomeView());
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

    if (filmsInTheaters.isEmpty) return CircularProgressIndicator();

    return ListView.builder(
      itemCount: filmsInTheaters.length,
      itemBuilder: (context, index) {
        final film = filmsInTheaters[index];
        return ListTile(title: Text(film.title));
      },
    );
  }
}
