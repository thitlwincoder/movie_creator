import 'package:movie_creator/movie_creator.dart';

class GifLayer extends Layer {
  GifLayer.asset(
    this.path, {
    this.x,
    this.y,
    this.width,
    this.height,
    this.rotate,
    this.opacity,
  }) : type = FileType.asset;

  GifLayer.file(
    this.path, {
    this.x,
    this.y,
    this.width,
    this.height,
    this.rotate,
    this.opacity,
  }) : type = FileType.file;

  final String path;
  final FileType type;

  int? x;
  int? y;

  int? height;
  int? width;

  double? rotate;
  double? opacity;

  Future<bool> export(String input, int? fps, String output) async {
    var path = this.path;

    if (type == FileType.asset) {
      path = await moveAssetToTemp(path);
    }

    final overlay = 'overlay=${x ?? '(W-w)/2'}:${y ?? '(H-h)/2'}:shortest=1';

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

    if (rotate != null) {
      buffer.write('rotate=$rotate;');
    }

    // buffer.write('shortest=1');

    return ffmpeg.execute([
      '-i',
      input,
      '-stream_loop',
      '-1',
      '-i',
      path,
      if (fps != null) ...['-r', '$fps'],
      '-filter_complex',
      buffer.toString(),
      '-c:a',
      'copy',
      output,
      '-y'
    ]);
  }
}
