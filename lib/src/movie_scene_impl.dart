import 'package:flutter/material.dart';
import 'package:movie_creator/movie_creator.dart';

class MovieSceneImpl implements MovieScene {
  MovieSceneImpl({
    required this.duration,
    Color? color,
    List<Layer>? layers,
  })  : _layers = layers ?? [],
        color = color ?? Colors.black;

  final int duration;

  final Color color;

  String? _temp;

  List<Layer> _layers = [];

  @override
  String? get temp => _temp;

  @override
  set temp(String? value) => _temp = value;

  @override
  List<Layer> get layers => _layers;

  @override
  set layers(List<Layer> value) => _layers = value;

  @override
  void addLayer(Layer layer) {
    _layers.add(layer);
  }

  @override
  Future<bool> exportBgVideo(int width, int height, int? fps, String output) {
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
