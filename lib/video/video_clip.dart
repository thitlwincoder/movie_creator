import 'package:movie_flutter/movie_flutter.dart' show Clip;

abstract class VideoClip extends Clip {
  VideoClip();

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
}
