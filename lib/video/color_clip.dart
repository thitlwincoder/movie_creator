import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_flutter/movie_flutter.dart'
    show
        Clip,
        ColorExt,
        FFMpegCommand,
        ImageClip,
        TextClip,
        cmdPrint,
        drawtextCMD,
        ffmpeg;
import 'package:movie_flutter/video/utils/transition.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ColorClip extends Clip {
  ColorClip({
    required this.color,
    required Duration duration,
    Transition? transition,
    this.rate = 30,
    this.size = const Size(320, 240),
    this.layers = const [],
  }) {
    super.duration = duration;
  }

  final Color color;
  final Size size;
  final int rate;
  final List<Clip> layers;

  @override
  Future<void> writeVideoFile(File output) async {
    final fontfile = await setFontDirectory();

    final sizeFormat = '${size.width.toInt()}x${size.height.toInt()}';

    final tmpPaths = [await getTemp('bg.mp4')];

    await ffmpeg.execute([
      '-f',
      'lavfi',
      '-i',
      'color='
          'c=${color.toHex}:'
          's=$sizeFormat:'
          'd=${duration!.inSeconds}',
      tmpPaths.last,
      '-y'
    ]);

    final textClips = layers.whereType<TextClip>().toList();

    layers.removeWhere((e) => e is TextClip);
    final otherClips = layers;

    var i = 1;

    final tmpName = await getTemp('tmp$i.mp4');

    await Future.forEach(otherClips, (clip) async {
      if (clip is ImageClip) {
        final path = await moveAssetToTemp(clip.path);

        final ps = clip.getPositions(clip.alignment, clip.padding);

        await ffmpeg.execute([
          '-i',
          tmpPaths.last,
          '-i',
          path,
          '-filter_complex',
          '[0:v][1:v]overlay=$ps',
          '-c:a',
          'copy',
          tmpName,
          '-y'
        ]);

        tmpPaths.add(tmpName);
      }

      i++;
    });

    if (textClips.length > 1) {
      await ffmpeg.execute([
        '-i',
        tmpPaths.last,
        '-filter_complex',
        '"${[
          for (final e in textClips)
            drawtextCMD(
              e.text,
              alignment: e.alignment,
              bgcolor: e.backgroundColor,
              padding: e.padding,
              fontcolor: e.color ?? Colors.black,
              fontsize: e.fontSize ?? 20,
              fontfile: fontfile.path,
            )
        ].join(', ')}"',
        '-c:a',
        'copy',
        output.path,
        '-y'
      ]);
    } else {
      final e = textClips.first;

      await ffmpeg.execute([
        '-i',
        tmpPaths.last,
        '-vf',
        drawtextCMD(
          e.text,
          alignment: e.alignment,
          bgcolor: e.backgroundColor,
          padding: e.padding,
          fontcolor: e.color ?? Colors.black,
          fontsize: e.fontSize ?? 20,
          fontfile: fontfile.path,
        ),
        '-c:a',
        'copy',
        output.path,
        '-y'
      ]);
    }
  }
}

Future<String> getTemp(String name) async {
  final dir = await getTemporaryDirectory();

  final temp = p.join(dir.path, name);

  await File(temp).create();
  return temp;
}

Future<String> moveAssetToTemp(String path) async {
  final tmp = await getTemp(p.basename(path));

  final bytes = await rootBundle.load(path);
  await File(tmp).writeAsBytes(bytes.buffer.asUint8List());

  return tmp;
}
