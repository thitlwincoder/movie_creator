import 'dart:io';

import 'package:moviepy_flutter/moviepy_flutter.dart'
    show VideoFileClip, ffmpeg;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CompositeVideoClip {
  CompositeVideoClip(
    this.clips,
  );

  final List<VideoFileClip> clips;

  Future<void> writeVideoFile(File output) async {
    final contents = StringBuffer();

    final temp = await getTemporaryDirectory();

    await Future.forEach(clips, (clip) async {
      final file =
          File(p.join(temp.path, '${DateTime.now().millisecond}.webm'));
      await file.create();

      await clip.writeVideoFile(file);
      contents.writeln("file '${file.path}'");
    });

    final tempTxt =
        File(p.join(temp.path, '${DateTime.now().millisecond}.txt'));
    await tempTxt.writeAsString(contents.toString());

    await ffmpeg.execute([
      '-f',
      'concat',
      '-safe',
      '0',
      '-i',
      tempTxt.path,
      '-c',
      'copy',
      output.path,
      '-y'
    ]);
  }
}
