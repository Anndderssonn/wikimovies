import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/domain/entities/movie.dart';
import 'movies_providers.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  final filmsInTheaters = ref.watch(filmsInTheatersProvider);
  if (filmsInTheaters.isEmpty) {
    return [];
  }
  return filmsInTheaters.sublist(0, 6);
});
