import 'package:movie_creator/layers/video_layer_impl.dart';
import 'package:movie_creator/movie_creator.dart';

abstract class VideoLayer extends Layer {
  factory VideoLayer.asset(
    String path, {
    int? x,
    int? y,
    int? width,
    int? height,
    bool? isMute,
  }) = VideoLayerImpl.asset;

  factory VideoLayer.file(
    String path, {
    int? x,
    int? y,
    int? width,
    int? height,
    bool? isMute,
  }) = VideoLayerImpl.file;

  // Cutting and Trimming
  // -  Cut and trim video clips.
  // -  Split and join clips.

  // Audio Editing
  // -  Adjust volume levels.
  // -  Add background music or sound effects.

  // Speed and Time Effects
  // -  Speed up or slow down clips.zz
  // -  Create time-lapse or slow-motion effects.

  Future<bool> export(String input, int? fps, String output);
}
