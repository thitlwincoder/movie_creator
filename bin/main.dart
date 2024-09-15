import 'package:flutter/material.dart';
import 'package:movie_creator/movie_creator.dart';

Future<void> main() async {
  final creator = MovieCreator(height: 720, width: 720);

  final scene = MovieScene(duration: 10);

  final text = TextLayer(
    'Hello',
    fontSize: 10,
    color: Colors.red,
  );

  scene.addLayer(text);

  creator.addScene(scene);

  await creator.export();
}
