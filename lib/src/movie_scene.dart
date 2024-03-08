import 'package:flutter/material.dart';
import 'package:movie_flutter/movie_flutter.dart';

class MovieScene {
  MovieScene({required this.duration, this.bgColor = Colors.black});

  Color bgColor;

  double duration;

  List<Layer> layers = [];

  void addLayer(Layer layer) {
    layers.add(layer);
  }

  Future<bool> exportBgVideo(
    int width,
    int height,
    int fps,
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
