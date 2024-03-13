import 'package:movie_creator/movie_creator.dart';

class ImageLayer extends Layer {
  ImageLayer.asset(
    this.path, {
    this.x,
    this.y,
    // this.rotate,
    this.opacity,
  }) : type = FileType.asset;

  ImageLayer.file(
    this.path, {
    this.x,
    this.y,
    this.opacity,
  }) : type = FileType.file;

  final String path;
  final FileType type;

  int? x;
  int? y;

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

  Future<String> _initPath() async {
    if (_temp != null) return _temp!;

    var path = this.path;

    if (type.isAsset) path = await moveAssetToTemp(path);

    return path;
  }

  Future<void> crop({required int width, required int height}) async {
    _temp = await _generator.crop(await _initPath(), width, height);
  }

  Future<void> rotate(int degree) async {
    _temp = await _generator.rotate(await _initPath(), degree);
  }

  Future<void> hflip() async {
    _temp = await _generator.hflip(await _initPath());
  }

  Future<void> vflip() async {
    _temp = await _generator.vflip(await _initPath());
  }

  Future<void> brightness(double value) async {
    _temp = await _generator.brightness(await _initPath(), value);
  }

  Future<void> contrast(double value) async {
    _temp = await _generator.contrast(await _initPath(), value);
  }

  Future<void> saturation(double value) async {
    _temp = await _generator.saturation(await _initPath(), value);
  }

  Future<void> gamma(double value) async {
    _temp = await _generator.gamma(await _initPath(), value);
  }

  Future<bool> save(String output) async {
    return _generator.save(await _initPath(), output);
  }

  Future<bool> export(String input, int? fps, String output) async {
    final overlay = 'overlay=${x ?? '(W-w)/2'}:${y ?? '(H-h)/2'}';

    final buffer = StringBuffer();

    if (opacity != null) {
      buffer.write(
        '[1:v]format=rgba,colorchannelmixer=aa=$opacity[ov];[0:v][ov]$overlay;',
      );
    } else {
      buffer.write('"[0:v][1:v]$overlay;"');
    }

    if (height != null || width != null) {
      buffer.write('scale=${height ?? -1}:${width ?? -1};');
    }

    // if (rotate != null) {
    //   buffer.write('rotate=$rotate;');
    // }

    return ffmpeg.execute([
      '-i',
      input,
      if (fps != null) ...['-r', '$fps'],
      '-i',
      await _initPath(),
      '-filter_complex',
      buffer.toString(),
      '-c:a',
      'copy',
      output,
      '-y'
    ]);
  }
}
