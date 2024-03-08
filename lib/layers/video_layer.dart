import 'package:movie_flutter/movie_flutter.dart';

class VideoLayer extends Layer {
  VideoLayer.asset(
    this.path, {
    this.x,
    this.y,
    this.width,
    this.height,
    this.isMute = false,
  }) : type = FileType.asset;

  VideoLayer.file(
    this.path, {
    this.x,
    this.y,
    this.width,
    this.height,
    this.isMute = false,
  }) : type = FileType.file;

  final String path;
  final FileType type;

  int? x;
  int? y;

  int? height;
  int? width;

  bool isMute;

  Future<bool> export(String input, String output) async {
    var path = this.path;

    if (type == FileType.asset) {
      path = await moveAssetToTemp(path);
    }

    final buffer = StringBuffer();

    final overlay = 'overlay=${x ?? '(W-w)/2'}:${y ?? '(H-h)/2'}';

    if (height != null || width != null) {
      buffer.write(
        '[1:v]scale=${height ?? -1}:${width ?? -1}[ov];[0:v][ov]$overlay;',
      );
    } else {
      buffer.write('"[0:v][1:v]$overlay;"');
    }

    final audiocmd = [
      if (isMute) ...['-an', ' -c:v'] else '-c:a',
    ];

    return ffmpeg.execute([
      '-i',
      input,
      '-i',
      path,
      '-filter_complex',
      buffer.toString(),
      ...audiocmd,
      'copy',
      output,
      '-y',
    ]);
  }
}
