import 'package:movie_creator/core/core.dart';
import 'package:movie_creator/layers/gif_layer.dart';
import 'package:movie_creator/utils/temp.dart';

class GifLayerImpl implements GifLayer {
  GifLayerImpl.asset(
    this.path, {
    this.x,
    this.y,
    this.width,
    this.height,
    this.rotate,
    this.opacity,
  }) : type = FileType.asset;

  GifLayerImpl.file(
    this.path, {
    this.x,
    this.y,
    this.width,
    this.height,
    this.rotate,
    this.opacity,
  }) : type = FileType.file;

  String path;
  int? x;
  int? y;
  int? width;
  int? height;
  double? rotate;
  double? opacity;
  FileType type;

  @override
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
