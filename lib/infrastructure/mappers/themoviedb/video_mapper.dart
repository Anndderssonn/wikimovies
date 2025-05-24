import 'package:wiki_movies/domain/entities/video.dart';
import 'package:wiki_movies/infrastructure/models/models.dart';

class VideoMapper {
  static theMovieDBVideoToEntity(Result movieDBVideo) => Video(
    id: movieDBVideo.id,
    name: movieDBVideo.name,
    youtubeKey: movieDBVideo.key,
    publishedAt: movieDBVideo.publishedAt,
  );
}
