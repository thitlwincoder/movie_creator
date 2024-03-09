import 'dart:io';

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:movie_creator/movie_creator.dart';
import 'package:path/path.dart' as p;

Future<void> album() async {
  const bg = 'assets/imgs/bg/02.jpeg';
  const img1 = 'assets/imgs/album/01.jpeg';
  const img2 = 'assets/imgs/album/02.jpeg';
  const img3 = 'assets/imgs/album/03.jpeg';
  const img4 = 'assets/imgs/album/04.jpeg';

  const width = 576;
  const height = 1024;

  final creator = MovieCreator(
    height: height,
    width: width,
    fps: 24,
  );

  final scene1 = MovieScene(
    duration: 6,
    bgColor: Colors.red,
  )..temp = 'scene1';

  final scene2 = MovieScene(
    duration: 6,
    bgColor: Colors.green,
  )..temp = 'scene2';

  final scene3 = MovieScene(
    duration: 6,
    bgColor: Colors.yellow,
  )..temp = 'scene3';

  creator
    ..addScene(scene1)
    ..addScene(scene2)
    ..addScene(scene3);

  final dir = await getDirectoryPath();

  final file = File(p.join(dir!, 'example.mp4'));

  await creator.export(file.path);
}
