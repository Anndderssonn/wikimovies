import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  static const name = 'movie-detail-screen';

  final String movieID;

  const MovieDetailScreen({super.key, required this.movieID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Movie ID: $movieID')));
  }
}
