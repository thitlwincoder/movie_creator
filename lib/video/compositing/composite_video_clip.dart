import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:flutter/services.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart' show Clip;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CompositeVideoClip {
  CompositeVideoClip(
    this.clips,
  );

  final List<Clip> clips;

  Future<void> writeVideoFile(File output) async {
    for (final e in clips) {
      await e.writeVideoFile(output);
    }

    return;
    final font = await rootBundle.load('assets/Baloo2-Medium.ttf');
    final docDir = await getApplicationDocumentsDirectory();
    final path = p.join(docDir.path, 'Baloo2-Medium.ttf');
    final file = File(path);
    await file.create();
    await file.writeAsBytes(font.buffer.asUint8List(
      font.offsetInBytes,
      font.lengthInBytes,
    ));

    await FFmpegKitConfig.setFontDirectory(file.path);

    final videos = [];

    final cmd = [
      // '-i',
      // 'background.mp4',
      // '-i',
      // 'overlay.mp4',
      '-filter_complex',
      '"[0:v][1:v]overlay=25:25[outv]"',
      '-map',
      '"[outv]"',
      '-c:v',
      'libx264',
      '-crf',
      '23',
      '-preset',
      'veryfast',
      'output.mp4\n'
    ];
  }
}
