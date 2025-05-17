import 'package:wiki_movies/domain/entities/movie.dart';
import 'package:wiki_movies/infrastructure/models/themoviedb/movie_themoviedb.dart';

class MovieMapper {
  static Movie theMovieDBToEntity(MovieTheMovieDB theMovieDB) => Movie(
    adult: theMovieDB.adult,
    backdropPath:
        (theMovieDB.backdropPath != '')
            ? 'https://image.tmdb.org/t/p/w500${theMovieDB.backdropPath}'
            : 'https://cdn.displate.com/artwork/857x1200/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg',
    genreIds: theMovieDB.genreIds.map((e) => e.toString()).toList(),
    id: theMovieDB.id,
    originalLanguage: theMovieDB.originalLanguage,
    originalTitle: theMovieDB.originalTitle,
    overview: theMovieDB.overview,
    popularity: theMovieDB.popularity,
    posterPath:
        (theMovieDB.posterPath != '')
            ? 'https://image.tmdb.org/t/p/w500${theMovieDB.posterPath}'
            : 'no-poster',
    releaseDate: theMovieDB.releaseDate,
    title: theMovieDB.title,
    video: theMovieDB.video,
    voteAverage: theMovieDB.voteAverage,
    voteCount: theMovieDB.voteCount,
  );
}
