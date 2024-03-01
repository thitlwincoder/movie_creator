import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_flutter/movie_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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

abstract class Clip {
  Clip();

  Duration duration = Duration.zero;
  Size size = Size.zero;

  String prefix = '';

  Future<void> setFontDirectory() {
    return FFmpegKitConfig.setFontDirectory('/system/fonts/');
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

  String getPositions(
    Alignment align, [
    EdgeInsets? padding,
    Transition? transition,
  ]) {
    // if (transition == Transition.shake) {
    //   return "x='if(lte(mod(t,2),1),random(10)*10,0)':y='if(lte(mod(t,2),1),random(10)*10,0)'";
    // }

    padding ??= EdgeInsets.zero;

    final t = padding.top.toInt();
    final b = padding.bottom.toInt();
    final l = padding.left.toInt();
    final r = padding.right.toInt();

    if (align.x > 1 || align.y > 1) {
      return 'x=${align.x}:y=${align.y}';
    }

    if (align == Alignment.topLeft) return 'x=$l:y=$t';
    if (align == Alignment.topCenter) return 'x=(w-text_w)/2:y=$t';
    if (align == Alignment.topRight) return 'x=w-tw-$r:y=$t';
    if (align == Alignment.bottomLeft) return 'x=$l:y=h-th-$b';
    if (align == Alignment.bottomCenter) return 'x=(w-text_w)/2:y=h-th-$b';
    if (align == Alignment.bottomRight) return 'x=w-tw-$r:y=h-th-$b';

    return 'x=(w-text_w)/2:y=(h-text_h)/2';
  }
}
