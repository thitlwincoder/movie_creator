import 'package:movie_creator/movie_creator.dart';
import 'package:path/path.dart' as p;

class AlbumLayer extends Layer {
  AlbumLayer.asset({
    required this.paths,
    this.x,
    this.y,
    this.width,
    this.height,
    this.duration,
  }) : type = FileType.asset;

  AlbumLayer.file({
    required this.paths,
    this.x,
    this.y,
    this.width,
    this.height,
    this.duration,
  }) : type = FileType.file;

  final List<String> paths;
  final FileType type;

  int? x;
  int? y;

  int? height;
  int? width;

  double? duration;

  Future<bool> export(String intput, int? fps, String output) async {
    var paths = <String>[];

    if (type == FileType.asset) {
      var i = 0;
      for (final path in this.paths) {
        paths.add(await moveAssetToTemp(path, name: 'img_$i'));
        i++;
      }
    } else {
      paths = this.paths;
    }

    final f = duration == null ? 1 : 1 / duration!;

    final temp = await getTemp(p.extension(output));

    final isSuccess = await ffmpeg.execute([
      '-framerate',
      '$f',
      if (fps != null) ...['-r', '$fps'],
      '-i',
      p.join(p.dirname(paths.first), 'img_%d${p.extension(paths.first)}'),
      temp,
      '-y'
    ]);

    if (!isSuccess) return false;

    final buffer = StringBuffer();

    final overlay = 'overlay=${x ?? '(W-w)/2'}:${y ?? '(H-h)/2'}';

    if (height != null || width != null) {
      buffer.write(
        '[1:v]scale=${height ?? -1}:${width ?? -1}[ov];[0:v][ov]$overlay;',
      );
    } else {
      buffer.write('"[0:v][1:v] $overlay;"');
    }

    return ffmpeg.execute([
      '-i',
      intput,
      '-r',
      '$fps',
      '-i',
      temp,
      '-filter_complex',
      buffer.toString(),
      output,
      '-y'
    ]);
  }
}
