import 'dart:io';

import 'gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:movie_creator/movie_creator.dart';

Future<File> main() {
  var bg1 = Assets.imgs.bg.a05.path;
  // var bg2 = Assets.imgs.bg.a04.path;
  var logo2 = Assets.imgs.logo.logo2.path;
  var cloud = Assets.imgs.cloud.path;
  var mars = Assets.imgs.mars.path;
  var rock = Assets.imgs.rock.path;
  var title = Assets.imgs.title.path;
  // var audio = Assets.audio.a05;

  var width = 576;
  var height = 1024;

  final creator = MovieCreator(
    fps: 30,
    width: width,
    height: height,
    scenes: [
      MovieScene(
        duration: 8,
        color: const Color(0xff0b0be6),
        layers: [
          ImageLayer.asset(bg1, x: width / 2, y: height / 2),
          ImageLayer.asset(cloud, x: width),
          ImageLayer.asset(mars, x: width / 2, y: height / 2),
          ImageLayer.asset(rock, x: width / 2 + 100),
          ImageLayer.asset(title, x: width / 2, y: height / 2 - 300),
          ImageLayer.asset(logo2, x: width / 2, y: 50, scale: .8),
        ],
      ),
    ],
  );

  return creator.export();
}
