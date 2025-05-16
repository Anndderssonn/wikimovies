import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  static String theMovieDBKey =
      dotenv.env['THE_MOVIE_DB_KEY'] ?? 'The MovieDB Api Key not found';
}
