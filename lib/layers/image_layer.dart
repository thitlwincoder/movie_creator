import 'package:movie_creator/movie_creator.dart';

class Alignment {
  Alignment({this.x, this.y});

  final int? x;
  final int? y;
}

class ImageLayer extends Layer {
  ImageLayer.asset(
    this.path, {
    this.opacity,
  }) : type = FileType.asset;

  ImageLayer.file(
    this.path, {
    this.opacity,
  }) : type = FileType.file;

  final String path;
  final FileType type;

  Alignment? alignment;

  int? height;
  int? width;

  double? opacity;

  final _generator = ImageGenerator.instance;

  String? _temp;

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

  Future<String> _getPath() async {
    if (_temp != null) return _temp!;

    var path = this.path;

    if (type.isAsset) path = await moveAssetToTemp(path);

    return path;
  }

  Future<void> crop({required int width, required int height}) async {
    _temp = await _generator.crop(await _getPath(), width, height);
  }

  Future<void> rotate(int degree) async {
    _temp = await _generator.rotate(await _getPath(), degree);
  }

  Future<void> hflip() async {
    _temp = await _generator.hflip(await _getPath());
  }

  Future<void> vflip() async {
    _temp = await _generator.vflip(await _getPath());
  }

  Future<void> brightness(double value) async {
    _temp = await _generator.brightness(await _getPath(), value);
  }

  Future<void> contrast(double value) async {
    _temp = await _generator.contrast(await _getPath(), value);
  }

  Future<void> saturation(double value) async {
    _temp = await _generator.saturation(await _getPath(), value);
  }

  Future<void> gamma(double value) async {
    _temp = await _generator.gamma(await _getPath(), value);
  }

  Future<bool> save(String output) async {
    return _generator.save(await _getPath(), output);
  }

  Future<bool> export(String input, int? fps, String output) async {
    final overlay =
        "overlay=${alignment?.x ?? '(W-w)/2'}:${alignment?.y ?? '(H-h)/2'}";

    final buffer = StringBuffer();

    if (opacity != null) {
      buffer.write('"$overlay:alpha=$opacity"');
    } else {
      buffer.write('"$overlay;"');
    }

    if (height != null || width != null) {
      buffer.write('scale=${height ?? -1}:${width ?? -1};');
    }

    return ffmpeg.execute([
      '-i',
      input,
      if (fps != null) ...['-r', '$fps'],
      '-i',
      await _getPath(),
      '-filter_complex',
      buffer.toString(),
      output,
      '-y'
    ]);
  }
}
