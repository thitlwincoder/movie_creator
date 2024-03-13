import 'dart:io';

import 'package:example/main.dart';
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

  final image = ImageLayer.asset(img1);
  await image.hflip();
  await image.vflip();

  final creator = MovieCreator(
    height: height,
    width: width,
    fps: 24,
  );

  final scene1 = MovieScene(duration: 6)..addLayer(image);
  // ..addLayer(GifLayer.asset('assets/imgs/gif/girl.gif'))
  // ..addLayer(GifLayer.asset('assets/imgs/gif/m.gif', x: 0, y: 0));

  creator.addScene(scene1);
  // ..addScene(scene2);

  final dir = await getDirectoryPath();

  final file = File(p.join(dir!, 'example.mp4'));

  final watch = Stopwatch()..start();

  await creator.export(file.path);

  watch.stop();

  print('duration: ${watch.elapsed}');
}
