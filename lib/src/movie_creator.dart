import 'dart:io';

import 'package:movie_creator/movie_creator.dart';
import 'package:movie_creator/src/movie_creator_impl.dart';

abstract class MovieCreator {
  factory MovieCreator({
    required int height,
    required int width,
    int? fps,
    Map<String, FontFile>? fonts,
    List<MovieScene>? scenes,
  }) = MovieCreatorImpl;

  void addScene(MovieScene scene);

  void addFont({
    required FontFile fontFile,
    required String fontFamily,
  });

  Future<File> export({String extension = 'mp4'});

  Future<void> clearTemps();
}
