import 'package:wiki_movies/domain/datasources/actors_datasource.dart';
import 'package:wiki_movies/domain/entities/actor.dart';
import 'package:wiki_movies/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {
  final ActorsDatasource actorsDatasource;

  ActorRepositoryImpl(this.actorsDatasource);

  @override
  Future<List<Actor>> getActorsByMovie(String movieID) {
    return actorsDatasource.getActorsByMovie(movieID);
  }
}
