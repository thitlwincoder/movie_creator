import 'package:flutter/material.dart';
import 'package:movie_creator/movie_creator.dart';

class MovieScene {
  MovieScene({
    required this.duration,
    this.color = Colors.black,
    // this.transition,
  });

  Color color;

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
    final cmd = ColorCmd(
      fps: fps,
      width: width,
      color: color,
      height: height,
      duration: duration,
    );

    return ffmpeg.execute(['-f', 'lavfi', '-i', '$cmd', output, '-y']);
  }
}
