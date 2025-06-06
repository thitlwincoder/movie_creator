import 'package:movie_creator/movie_creator.dart';
import 'package:movie_creator/utils/temp.dart';

class VideoLayerImpl implements VideoLayer {
  VideoLayerImpl.asset(
    this.path, {
    this.x,
    this.y,
    this.width,
    this.height,
    bool? isMute,
  })  : isMute = isMute ?? false,
        type = FileType.asset;

  VideoLayerImpl.file(
    this.path, {
    this.x,
    this.y,
    this.width,
    this.height,
    bool? isMute,
  })  : isMute = isMute ?? false,
        type = FileType.file;

  final String path;
  final FileType type;

  int? x;
  int? y;

  int? height;
  int? width;

  bool isMute;

  @override
  Future<bool> export(String input, int? fps, String output) async {
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
      if (fps != null) ...['-r', '$fps'],
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
