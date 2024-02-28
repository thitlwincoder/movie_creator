import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviepy_flutter/core/core.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract class Clip {
  Clip();

  Duration? duration;

  Future<File> setFontDirectory() async {
    final font = await rootBundle.load('assets/Baloo2-Medium.ttf');
    final docDir = await getApplicationDocumentsDirectory();
    final path = p.join(docDir.path, 'Baloo2-Medium.ttf');
    final file = File(path);

    if (!file.existsSync()) {
      await file.create();
      await file.writeAsBytes(font.buffer.asUint8List(
        font.offsetInBytes,
        font.lengthInBytes,
      ));
    }

    await FFmpegKitConfig.setFontDirectory(file.path);

    return file;
  }

  Future<MemoryImage> getFrame(Duration position, File media) async {
    final name =
        Platform.isAndroid || Platform.isIOS ? 'image.jpg' : 'image.bmp';

    final dir = await getTemporaryDirectory();

    final temp = File(p.join(dir.path, name));

    await ffmpeg.execute([
      '-an',
      '-ss',
      '${position.inSeconds}',
      '-i',
      media.path.replaceAll(r'\', '/'),
      '-frames:v',
      '1',
      temp.path,
      '-y',
    ]);

    final data = await temp.readAsBytes();
    await temp.delete();

    return MemoryImage(data);
  }

  Future<String> save() async {
    return '';
  }

  Future<void> writeVideoFile(File output);
}
