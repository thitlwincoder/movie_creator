import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_flutter/movie_flutter.dart'
    show
        Clip,
        ImageClip,
        MultiImageClip,
        TextClip,
        colorCMD,
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
    Size? size,
    this.layers = const [],
  }) {
    super.duration = duration;
    if (size != null) super.size = size;
  }

  final Color color;
  final int rate;
  final List<Clip> layers;

  @override
  Future<void> writeVideoFile(File output) async {
    await setFontDirectory();

    final ext = p.extension(output.path);

    final tmpPaths = [await getTemp('${prefix}bg$ext')];

    await ffmpeg.execute([
      '-f',
      'lavfi',
      '-i',
      colorCMD(color: color, size: super.size, duration: duration),
      tmpPaths.last,
      '-y'
    ]);

    final textClips = layers.whereType<TextClip>().toList();

    layers.removeWhere((e) => e is TextClip);
    final otherClips = layers;

    var i = 1;

    var tmpName = await getTemp('${prefix}tmp$i$ext');

    await Future.forEach(otherClips, (clip) async {
      if (clip is MultiImageClip) {
        await overlayMultiImageOnVideo(
          tmpPaths.last,
          clip,
          tmpName,
          ext,
          prefix,
        );
        tmpPaths.add(tmpName);
        i += 1;
        tmpName = await getTemp('${prefix}tmp$i$ext');
      }

      if (clip is ImageClip) {
        final path = await moveAssetToTemp(clip.path);

        final ps =
            clip.getPositions(clip.alignment, clip.padding, clip.transition);

        await ffmpeg.execute([
          '-i',
          tmpPaths.last,
          '-i',
          path,
          '-filter_complex',
          '[0:v][1:v]overlay="$ps"',
          '-c:a',
          'copy',
          tmpName,
          '-y'
        ]);

        tmpPaths.add(tmpName);

        i += 1;
        tmpName = await getTemp('${prefix}tmp$i$ext');
      }
    });

    if (textClips.isEmpty) {
      await ffmpeg
          .execute(['-i', tmpPaths.last, '-c:a', 'copy', output.path, '-y']);
      return;
    }

    if (textClips.length > 1) {
      await ffmpeg.execute(
        overlayMultiTextOnVideo(tmpPaths.last, textClips, output),
      );
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
        ),
        '-c:a',
        'copy',
        output.path,
        '-y'
      ]);
    }
  }
}

Future<void> overlayMultiImageOnVideo(
  String input,
  MultiImageClip clip,
  String output,
  String ext,
  String prefix,
) async {
  var i = 0;

  final paths = <String>[];

  var imgExt = '';

  await Future.forEach(clip.paths, (path) async {
    imgExt = p.extension(path);
    paths.add(await moveAssetToTemp(path, name: '${prefix}img$i$imgExt'));
    i++;
  });

  final sizeFormat = '${clip.size.width.toInt()}x${clip.size.height.toInt()}';

  final tmp = await getTemp('${prefix}multi_img$ext');

  await ffmpeg.execute([
    '-framerate',
    '1',
    '-t',
    '${clip.duration.inSeconds}',
    '-i',
    p.join(p.dirname(paths.first), 'img%d$imgExt'),
    // '-vf',
    // '"${clip.transition},fps=25,scale=$sizeFormat"',
    tmp,
    '-y'
  ]);

  await ffmpeg.execute([
    '-i',
    input,
    '-i',
    tmp,
    '-filter_complex',
    '"[0:v][1:v] overlay=(W-w)/2:(H-h)/2"',
    output,
    '-y'
  ]);
}

List<String> overlayMultiTextOnVideo(
  String input,
  List<TextClip> clips,
  File output,
) {
  final cmd = ['-i', '"$input"', '-filter_complex'];

  final txts = <String>[];

  for (final e in clips) {
    txts.add(drawtextCMD(
      e.text,
      padding: e.padding,
      alignment: e.alignment,
      fontcolor: e.color ?? Colors.black,
      fontsize: e.fontSize ?? 20,
      effect: e.effect,
      start: e.start,
      end: e.end,
    ));
  }

  cmd
    ..add('"${txts.join(',')}"')
    ..addAll(['-c:a', 'copy', output.path, '-y']);

  return cmd;
}

Future<String> getTemp(String name) async {
  final dir = await getTemporaryDirectory();

  final temp = p.join(dir.path, name);

  await File(temp).create();
  return temp;
}

Future<String> moveAssetToTemp(String path, {String? name}) async {
  final bytes = await rootBundle.load(path);

  final tmp = await getTemp(name ?? p.basename(path));
  await File(tmp).writeAsBytes(bytes.buffer.asUint8List());

  return tmp;
}
