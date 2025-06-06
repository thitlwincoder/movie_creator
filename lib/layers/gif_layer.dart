import 'package:movie_creator/layers/gif_layer_impl.dart';
import 'package:movie_creator/movie_creator.dart';

abstract class GifLayer extends Layer {
  factory GifLayer.asset(
    String path, {
    int? x,
    int? y,
    int? width,
    int? height,
    double? rotate,
    double? opacity,
  }) = GifLayerImpl.asset;

  factory GifLayer.file(
    String path, {
    int? x,
    int? y,
    int? width,
    int? height,
    double? rotate,
    double? opacity,
  }) = GifLayerImpl.file;

  Future<bool> export(String input, int? fps, String output);
}
