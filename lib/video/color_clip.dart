import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_flutter/movie_flutter.dart'
    show
        Clip,
        ColorExt,
        FFMpegCommand,
        ImageClip,
        MutliImageClip,
        TextClip,
        cmdPrint,
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
      colorCMD(color: color, size: size, duration: duration),
      tmpPaths.last,
      '-y'
    ]);

    final textClips = layers.whereType<TextClip>().toList();

    layers.removeWhere((e) => e is TextClip);
    final otherClips = layers;

    var i = 1;

    var tmpName = await getTemp('tmp$i.mp4');

    await Future.forEach(otherClips, (clip) async {
      if (clip is MutliImageClip) {
        await overlayMultiImageOnVideo(tmpPaths.last, clip, tmpName);
        tmpPaths.add(tmpName);
        i += 1;
        tmpName = await getTemp('tmp$i.mp4');
      }

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

        i += 1;
        tmpName = await getTemp('tmp$i.mp4');
      }
    });

    if (textClips.isEmpty) {
      await ffmpeg
          .execute(['-i', tmpPaths.last, '-c:a', 'copy', output.path, '-y']);
      return;
    }

    if (textClips.length > 1) {
      await ffmpeg.execute(
        overlayMultiTextOnVideo(tmpPaths.last, textClips, fontfile, output),
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

Future<void> overlayMultiImageOnVideo(
  String input,
  MutliImageClip clip,
  String output,
) async {
  var i = 0;

  final paths = <String>[];
  var ext = '';

  await Future.forEach(clip.paths, (path) async {
    ext = p.extension(path);

    paths.add(await moveAssetToTemp(path, name: 'img$i$ext'));
    i++;
  });

  final sizeFormat = '${clip.size.width.toInt()}x${clip.size.height.toInt()}';

  final tmp = await getTemp('multi_img.mp4');

  await ffmpeg.execute([
    '-framerate',
    '1/2',
    '-t',
    '${clip.duration?.inSeconds ?? 5}',
    '-i',
    p.join(p.dirname(paths.first), 'img%d$ext'),
    '-vf',
    '"scale=$sizeFormat"',
    // '-r',
    // '4',
    // '-pix_fmt',
    // 'yuv420p',
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
  File fontfile,
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
      fontfile: fontfile.path,
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
