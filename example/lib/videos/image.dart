// import 'dart:io';

// import 'package:example/main.dart';
// import 'package:flutter/material.dart';
// import 'package:movie_creator/movie_creator.dart';
// import 'package:path/path.dart' as p;

// Future<void> image() async {
//   const bg1 = 'assets/imgs/bg/05.jpg';
//   const bg2 = 'assets/imgs/bg/04.jpeg';
//   const logo2 = 'assets/imgs/logo/logo2.png';
//   const cloud = 'assets/imgs/cloud.png';
//   const mars = 'assets/imgs/mars.png';
//   const rock = 'assets/imgs/rock.png';
//   const title = 'assets/imgs/title.png';
//   const audio = 'assets/audio/05.wav';

//   const width = 576.0;
//   const height = 1024.0;

//   final scene1 = ColorClip(
//     color: Color(0xff0b0be6),
//     duration: Duration(seconds: 8),
//     size: Size(width, height),
//   );
//   final scene2 =
//       ColorClip(color: Color(0xffb33771), duration: Duration(seconds: 5));

//   final fbg1 = ImageClip(path: bg1, alignment: Alignment.topLeft);
//   scene1.addLayer(fbg1);

//   final fcloud = ImageClip(path: cloud, alignment: AlignmentX(width));
//   scene1.addLayer(fcloud);

//   final fmars = ImageClip(path: mars, alignment: Alignment.center);
//   // ..addEffects([EffectType.rollIn, EffectType.zoomIn], time: 1.8, delay: .8);

//   scene1.addLayer(fmars);

//   final frock = ImageClip(
//     path: rock,
//     alignment: Alignment(width / 2 + 100, height / 2 + 100),
//   )..rotate(10);
//   // ..addAnimate(
//   //   from: AlignmentY(height / 2 + 720),
//   //   to: AlignmentY(height / 2 + 100),
//   //   duration: 1,
//   //   curve: Curves.easeInOutCubic,
//   //   delay: 2.3,
//   // );

//   scene1.addLayer(frock);

//   final ftitle = ImageClip(
//     path: title,
//     alignment: AlignmentY(height / 2 - 300),
//   );
//   // ..addEffect(Effect.fadeInUp, time: 1, delay: 1.4);

//   scene1.addLayer(ftitle);
//   //   ..setTransition(type: TransitionType.circleclose, duration: 1.5)
//   //   ..getCMD();

//   // final fbg2 = ImageClip(path: bg2, alignment: Alignment.center);
//   // scene2.addLayer(fbg2);

//   // final flogo2 = ImageClip(
//   //   path: logo2,
//   //   alignment: Alignment(width / 2, height / 2 - 80),
//   // )
//   //   ..setScale(.9)
//   //   ..addEffect(Effect.fadeInUp, time: 1, delay: 1.2)
//   //   ..remove(9);

//   // scene2.addLayer(flogo2);

//   // final creator = CompositeVideoClip(
//   //   size: Size(width, height),
//   //   clips: [scene1, scene2],
//   // );

//   final dir = await getDirectoryPath();

//   final file = File(p.join(dir!, 'image.mp4'));

//   if (file.existsSync()) await file.delete();

//   await scene1.writeVideoFile(file);
// }
