import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:wiki_movies/domain/entities/entities.dart';
import 'package:wiki_movies/presentation/providers/providers.dart';

final FutureProviderFamily<List<Video>, int> videosFromMovieProvider =
    FutureProvider.family((ref, int movieID) {
      final movieRepository = ref.watch(movieRepositoryProvider);
      return movieRepository.getYoutubeVideosByID(movieID);
    });

class VideosFromMovie extends ConsumerWidget {
  final int movieID;

  const VideosFromMovie({super.key, required this.movieID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesFromVideo = ref.watch(videosFromMovieProvider(movieID));

    return moviesFromVideo.when(
      data: (videos) => _VideosList(videos: videos),
      error:
          (error, stackTrace) => const Center(
            child: Text(
              'Oops! This video decided to take a break. Try reloading it before it asks for popcorn. 🍿😅',
            ),
          ),
      loading:
          () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _VideosList extends StatelessWidget {
  final List<Video> videos;

  const _VideosList({required this.videos});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    if (videos.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('Videos', style: textStyles.titleLarge),
        ),
        _YoutubeVideoPlayer(
          youtubeID: videos.first.youtubeKey,
          name: videos.first.name,
        ),
      ],
    );
  }
}

class _YoutubeVideoPlayer extends StatefulWidget {
  final String youtubeID;
  final String name;

  const _YoutubeVideoPlayer({required this.youtubeID, required this.name});

  @override
  State<_YoutubeVideoPlayer> createState() => __YoutubeVideoPlayerState();
}

class __YoutubeVideoPlayerState extends State<_YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeID,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name, style: textStyles.bodySmall),
          YoutubePlayer(controller: _controller),
        ],
      ),
    );
  }
}
