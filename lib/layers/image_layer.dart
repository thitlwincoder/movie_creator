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
    this.x,
    this.y,
    this.scale,
  }) : type = FileType.asset;

  ImageLayer.file(
    this.path, {
    this.opacity,
    this.x,
    this.y,
    this.scale,
  }) : type = FileType.file;

  final String path;
  final FileType type;

  num? x;
  num? y;

  double? opacity;
  double? scale;

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

  Future<bool> export(
    String input,
    int? fps,
    String output,
    int height,
    int width,
  ) async {
    var h = '0';
    var w = '0';

    if (y == null || y == height) {
      h = 'H-h';
    } else {
      final _h = height / 2;

      if (y == _h) {
        h = '(H-h)/2';
      } else if (y! < _h) {
        h = '(H-h)/2-${_h - y!}';
      } else if (y! > _h) {
        h = '(H-h)/2+${y! - _h}';
      }
    }

    if (x == null || x == width) {
      w = 'W-w';
    } else {
      final _w = width / 2;

      if (x == _w) {
        w = '(W-w)/2';
      } else if (x! < _w) {
        w = '(W-w)/2-${_w - x!}';
      } else if (x! > _w) {
        w = '(W-w)/2+${x! - _w}';
      }
    }

    final overlay = 'overlay=$w:$h';

    final buffer = StringBuffer();

    if (opacity != null) {
      buffer.write('"$overlay:alpha=$opacity"');
    } else {
      buffer.write('"$overlay,"');
    }

    if (scale != null) {
      buffer.write('"scale=iw*$scale:ih*$scale;"');
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
