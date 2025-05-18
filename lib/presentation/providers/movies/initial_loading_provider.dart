import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(filmsInTheatersProvider).isEmpty;
  final step2 = ref.watch(upcomingFilmsProvider).isEmpty;
  final step3 = ref.watch(popularFilmsProvider).isEmpty;
  final step4 = ref.watch(topRatedFilmsProvider).isEmpty;

  if (step1 || step2 || step3 || step4) return true;
  return false;
});
