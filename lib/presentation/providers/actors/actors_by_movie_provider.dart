import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wiki_movies/domain/entities/actor.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';

final actorsByMovieProvider = StateNotifierProvider<
  ActorByMovieNotifierController,
  Map<String, List<Actor>>
>((ref) {
  final fetchMovieID = ref.watch(actorsRepositoryProvider).getActorsByMovie;
  return ActorByMovieNotifierController(getActorsByMovie: fetchMovieID);
});

typedef GetActorsByMovieCallback = Future<List<Actor>> Function(String movieID);

class ActorByMovieNotifierController
    extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsByMovieCallback getActorsByMovie;

  ActorByMovieNotifierController({required this.getActorsByMovie}) : super({});

  Future<void> loadActorsByMovie(String movieID) async {
    if (state[movieID] != null) return;
    final actorsByMovie = await getActorsByMovie(movieID);
    state = {...state, movieID: actorsByMovie};
  }
}
