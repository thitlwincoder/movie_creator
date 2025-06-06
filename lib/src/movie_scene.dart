import 'package:flutter/material.dart';
import 'package:movie_creator/movie_creator.dart';
import 'package:movie_creator/src/movie_scene_impl.dart';

abstract class MovieScene {
  factory MovieScene({
    required int duration,
    Color? color,
    List<Layer>? layers,
  }) = MovieSceneImpl;

  String? get temp;

  set temp(String? value);

  List<Layer> get layers;

  set layers(List<Layer> value);

  void addLayer(Layer layer);

  Future<bool> exportBgVideo(
    int width,
    int height,
    int? fps,
    String output,
  );
}
