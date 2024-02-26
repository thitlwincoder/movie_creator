import 'dart:io';

import 'package:moviepy_flutter/moviepy_flutter.dart' show Clip;

class VideoClip extends Clip {
  VideoClip(super.media);

  // Future<void> saveFrame(
  //   File outputFile, {
  //   Duration position = Duration.zero,
  // }) async {
  //   // final frame = await getFrame(position);
  //   // await outputFile.writeAsBytes(frame.bytes);
  // }

  // Future<Future<Stream<List<int>>>> writeVideoFile(
  //   File outputFile,
  // ) async {
  //   final path = outputFile.path;
  //   final posixPath = path.replaceAll(r'\', '/');

  //   final name = p.basename(path);
  //   var ext = p.extension(path);
  //   ext = ext.substring(1).toLowerCase();

  //   return ffmpeg.executeStream(
  //     [
  //       // To ignore audio processing, Can improve performance.
  //       '-an',
  //       '-i',
  //       media,
  //       p.join(posixPath, name),
  //       '-y',
  //     ],
  //   );
  // }

  Future<void> writeVideoFile(File output) async {}
}
