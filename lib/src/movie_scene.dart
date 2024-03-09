import 'package:flutter/material.dart';
import 'package:movie_creator/movie_creator.dart';

class MovieScene {
  MovieScene({
    required this.duration,
    this.bgColor = Colors.black,
    // this.transition,
  });

  Color bgColor;

  int duration;

  String? temp;

  // Transition? transition;

  List<Layer> layers = [];

  void addLayer(Layer layer) {
    layers.add(layer);
  }

  Future<bool> exportBgVideo(
    int width,
    int height,
    int? fps,
    String output,
  ) {
    final color = ColorCmd(
      fps: fps,
      width: width,
      color: bgColor,
      height: height,
      duration: duration,
    );

    return ffmpeg.execute(['-f', 'lavfi', '-i', '$color', output, '-y']);
  }
}
