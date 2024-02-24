import 'dart:io';

import 'package:moviepy_flutter/clip.dart';
import 'package:moviepy_flutter/core/core.dart';
import 'package:path/path.dart' as p;

class VideoClip extends Clip {
  VideoClip(super.media);

  Future<void> saveFrame(
    File outputFile, {
    Duration position = Duration.zero,
  }) async {
    final frame = await getFrame(position);
    await outputFile.writeAsBytes(frame.bytes);
  }

  Future<Future<Stream<List<int>>>> writeVideoFile(
    File outputFile,
  ) async {
    final path = outputFile.path;
    final posixPath = path.replaceAll(r'\', '/');

    final name = p.basename(path);
    var ext = p.extension(path);
    ext = ext.substring(1).toLowerCase();

    return ffmpeg.executeStream(
      commands: [
        // To ignore audio processing, Can improve performance.
        '-an',
        '-i',
        media.path,
        p.join(posixPath, name),
        '-y',
      ],
    );
  }
}
