import 'dart:io';
import 'dart:ui';

import 'package:movie_flutter/movie_flutter.dart' show Clip, ffmpeg;
import 'package:movie_flutter/video/utils/transition.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CompositeVideoClip {
  CompositeVideoClip({
    required this.clips,
    required this.size,
    this.transition,
  });

  final Size size;
  final List<Clip> clips;
  final Transition? transition;

  Future<void> writeVideoFile(File output) async {
    final temp = await getTemporaryDirectory();

    final ext = p.extension(output.path);

    final paths = <String>[];
    final indexs = <String>[];

    var prefix = '0';

    await Future.forEach(clips, (clip) async {
      final file = File(p.join(temp.path, '${DateTime.now().millisecond}$ext'));
      await file.create();

      clip
        ..size = size
        ..prefix = prefix;

      await clip.writeVideoFile(file);

      // contents.writeln("file '${file.path}'");
      indexs.add('[${indexs.length}]');
      paths.add(file.path);
      prefix = '${indexs.length}';
    });

    // final tempTxt =
    //     File(p.join(temp.path, '${DateTime.now().millisecond}.txt'));
    // await tempTxt.writeAsString(contents.toString());

    await ffmpeg.execute([
      // '-f',
      // 'concat',
      // '-safe',
      // '0',
      for (final e in paths) ...['-i', e],
      if (transition != null) ...[
        '-filter_complex',
        '"${indexs.join()}$transition"',
      ],
      // '-c',
      // 'copy',
      output.path,
      '-y'
    ]);
  }
}
