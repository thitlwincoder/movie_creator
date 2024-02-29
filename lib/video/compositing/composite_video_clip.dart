import 'dart:io';

import 'package:moviepy_flutter/moviepy_flutter.dart'
    show Clip, Progress, VideoFileClip, ffmpeg;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CompositeVideoClip {
  CompositeVideoClip(
    this.clips,
  );

  final List<Clip> clips;

  Future<void> writeVideoFile(File output) async {
    final contents = StringBuffer();

    final temp = await getTemporaryDirectory();

    // await Future.forEach(clips, (clip) async {
    //   var file = clip.media;

    //   final haveLayers = clip.layers?.isNotEmpty ?? false;

    //   if (haveLayers) {
    //     file = File(p.join(temp.path, '${DateTime.now().millisecond}.webm'));
    //     await file.create();

    //     await clip.writeVideoFile(file);
    //   }

    //   contents.writeln("file '${file.path}'");

    //   if (haveLayers) return;

    //   final trim = clip.trim;

    //   if (trim == null) return;

    //   contents.writeln('inpoint ${trim.start.inSeconds}');

    //   if (trim.end != null) contents.writeln('outpoint ${trim.end?.inSeconds}');
    // });

    // final tempTxt =
    //     File(p.join(temp.path, '${DateTime.now().millisecond}.txt'));
    // await tempTxt.writeAsString(contents.toString());

    // await ffmpeg.execute([
    //   '-f',
    //   'concat',
    //   '-safe',
    //   '0',
    //   '-i',
    //   tempTxt.path,
    //   '-c',
    //   'copy',
    //   output.path,
    //   '-y'
    // ]);

    // await tempTxt.delete();
  }
}
