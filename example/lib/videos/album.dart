import 'dart:io';

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:movie_flutter/movie_flutter.dart';
import 'package:path/path.dart' as p;

Future<void> album() async {
  const bg = 'assets/imgs/bg/02.jpeg';
  const img1 = 'assets/imgs/album/01.jpeg';
  const img2 = 'assets/imgs/album/02.jpeg';
  const img3 = 'assets/imgs/album/03.jpeg';
  const img4 = 'assets/imgs/album/04.jpeg';

  const width = 576;
  const height = 1024;

  final creator = VideoCreator(height: height, width: width);

  final scene = MovieScene(duration: 6, bgColor: Color(0x0fffcc22));

  creator.addScene(scene);

  final image = ImageLayer.asset(bg);
  scene.addLayer(image);

  final text = TextLayer('Hello');

  scene.addLayer(text);

  final album = AlbumLayer.asset(
    paths: [img1, img2, img3, img4],
    x: 250,
    y: 300,
    width: 500,
    height: 300,
    duration: 2.5,
  );

  scene.addLayer(album);

  final video = VideoLayer.asset('assets/video/video1.mp4');

  scene.addLayer(video);

  final dir = await getDirectoryPath();

  final file = File(p.join(dir!, 'album.mp4'));

  await creator.export(file.path);
}
