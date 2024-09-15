import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_creator/movie_creator.dart' hide FileType;

Future<File> main() {
  final creator = MovieCreator(height: 720, width: 720)
    ..addScene(MovieScene(duration: 10, color: Colors.red));

  return creator.export();
}
