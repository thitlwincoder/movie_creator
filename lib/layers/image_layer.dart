import 'package:movie_creator/layers/image_layer_impl.dart';
import 'package:movie_creator/movie_creator.dart';

class Alignment {
  Alignment({this.x, this.y});

  final int? x;
  final int? y;
}

abstract class ImageLayer extends Layer {
  factory ImageLayer.asset(
    String path, {
    double? opacity,
    num? x,
    num? y,
    double? scale,
  }) = ImageLayerImpl.asset;

  factory ImageLayer.file(
    String path, {
    double? opacity,
    num? x,
    num? y,
    double? scale,
  }) = ImageLayerImpl.file;

  // Crop and Resize:
  // -  Crop an image to remove unwanted parts.
  // -  Resize images to specific dimensions.

  // Adjustments
  // -  Brightness and contrast adjustments.
  // -  Saturation and hue adjustments.
  // -  Levels and curves for fine-tuning.

  // Transformations
  // -  Rotate, flip, and skew images.
  // -  Perspective and distortion corrections.

  Future<void> crop({required int width, required int height});

  Future<void> rotate(int degree);

  Future<void> hflip();

  Future<void> vflip();

  Future<void> brightness(double value);

  Future<void> contrast(double value);

  Future<void> saturation(double value);

  Future<void> gamma(double value);

  Future<bool> save(String output);

  Future<bool> export(
    String input,
    int? fps,
    String output,
    int height,
    int width,
  );
}
