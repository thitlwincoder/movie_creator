import 'dart:io';

import 'package:example/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:movie_creator/movie_creator.dart';

Future<File> main() {
  var bg1 = Assets.imgs.bg.a05.path;
  var bg2 = Assets.imgs.bg.a04.path;
  var logo2 = Assets.imgs.logo.logo2.path;
  var cloud = Assets.imgs.cloud.path;
  var mars = Assets.imgs.mars.path;
  var rock = Assets.imgs.rock.path;
  var title = Assets.imgs.title.path;
  var audio = Assets.audio.a05;

  var width = 576;
  var height = 1024;

  final creator = MovieCreator(
    height: height,
    width: width,
    fps: 30,
  );

  var scene1 = MovieScene(duration: 8, color: const Color(0xff0b0be6));

  var fbg1 = ImageLayer.asset(bg1, x: width / 2, y: height / 2);
  scene1.addLayer(fbg1);

  var fcloud = ImageLayer.asset(cloud, x: width);
  scene1.addLayer(fcloud);

  var fmars = ImageLayer.asset(mars, x: width / 2, y: height / 2);
  scene1.addLayer(fmars);

  var frock = ImageLayer.asset(rock, x: width / 2 + 100);
  scene1.addLayer(frock);

  var ftitle = ImageLayer.asset(title, x: width / 2, y: height / 2 - 300);
  scene1.addLayer(ftitle);

  var flogo1 = ImageLayer.asset(logo2, x: width / 2, y: 50, scale: .8);
  scene1.addLayer(flogo1);

  creator.addScene(scene1);

  return creator.export();
}
