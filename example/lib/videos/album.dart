import 'dart:io';

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';
import 'package:moviepy_flutter/video/video.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;

Future<void> album() async {
  const bg = 'assets/imgs/bg/02.jpeg';
  const logo1 = 'assets/imgs/logo/logo1.png';
  const logo2 = 'assets/imgs/logo/logo2.png';
  const img1 = 'assets/imgs/album/01.jpeg';
  const img2 = 'assets/imgs/album/02.jpeg';
  const img3 = 'assets/imgs/album/03.jpeg';
  const img4 = 'assets/imgs/album/04.jpeg';
  const img5 = 'assets/imgs/album/05.jpeg';
  const cover = 'assets/imgs/cover/cover1.jpg';
  const audio = 'assets/audio/03.wav';

  const width = 576.0;
  const height = 1024.0;

  final scene1 = ColorClip(
    size: Size(width, height),
    color: Color(0xff3b3a98),
    duration: Duration(seconds: 3),
    transition: Transition('Shake', duration: Duration(seconds: 1)),
    layers: [
      // ImageClip.fromList(
      //   paths: [img1, img2, img3, img4, img5],
      //   size: Size(width, 384),
      //   alignment: Alignment(width / 2, height / 2),
      //   transition: Transition('zoomIn'),
      //   duration: Duration(seconds: 2),
      // ),
      TextClip(
        'DEMO',
        fontSize: 40,
        color: Color(0xffffffff),
        backgroundColor: Color(0xff01003c),
        padding: EdgeInsets.all(10),
        alignment: Alignment(width / 2, 150),
        effect: Effect('fadeInUp', time: 1, delay: 1),
      ),
      TextClip(
        'Text 2',
        fontSize: 24,
        color: Colors.white,
        alignment: Alignment(width / 2, 250),
        effect: Effect('fadeInUp', time: 1, delay: 2),
      ),
      ImageClip(
        path: logo2,
        alignment: Alignment(width / 2, 60),
        scale: .6,
      ),
    ],
  );

  // final scene2 = ColorClip(
  //   color: Color(0xffb33771),
  //   duration: Duration(seconds: 5),
  //   layers: [
  //     ImageClip(
  //       path: bg,
  //       alignment: Alignment(width / 2, height / 2),
  //     ),
  //     ImageClip(
  //       path: logo1,
  //       alignment: Alignment(width / 2, height / 2 - 150),
  //       effect: Effect('fadeInDown', time: 1, delay: 1.2),
  //     ),
  //   ],
  // );

  // CompositeVideoClip([scene1, scene2]);
  final dir = await getDirectoryPath();

  final file = File(p.join(dir!, 'album.mp4'));

  await scene1.writeVideoFile(file);

  await OpenFile.open(file.path);
}
