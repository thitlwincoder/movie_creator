import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart'
    show
        Clip,
        ColorExt,
        FFMpegCommand,
        ImageClip,
        TextClip,
        cmdPrint,
        drawtextCMD,
        ffmpeg;
import 'package:moviepy_flutter/video/utils/transition.dart';
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

    final filters = <String>[];

    final images = <String>[];
    final texts = <String>[];
    final prefixs = <String>[];

    final temp = await getTemporaryDirectory();

    for (final e in layers) {
      if (e is TextClip) {
        final prefix = e.text.toLowerCase().replaceAll(' ', '_');

        var cmd = drawtextCMD(
          e.text,
          fontcolor: e.color ?? Colors.black,
          fontsize: e.fontSize ?? 20,
          alignment: e.alignment,
          padding: e.padding,
          bgcolor: e.backgroundColor,
          fontfile: fontfile.path,
        );
        cmd = '$cmd[$prefix]';

        if (prefixs.isEmpty) {
          cmd = '${'[0:v]'}$cmd';
        } else {
          cmd = '[${prefixs.last}]$cmd';
        }

        texts.add(cmd);
        filters.add('$cmd,');

        prefixs.add(prefix);
      }

      if (e is ImageClip) {
        final bytes = await rootBundle.load(e.path);
        final byteList =
            bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

        final file = File(p.join(temp.path, p.basename(e.path)));
        await file.create();
        await file.writeAsBytes(byteList);

        images.add(file.path);

        // filters.add("movie='${file.path}'[logo];");
        // inputSourceCount++;
      }
    }

    // for (var i = 1; i <= inputSourceCount; i++) {
    //   input.write('[$i:v]');
    // }

    // filters.add('${input}overlay=(W-w)/2:60 [out]');

    final cmd = [
      '-f',
      'lavfi',
      '-i',
      'color='
          'c=${color.toHex}:'
          's=$sizeFormat:'
          'd=${duration!.inSeconds}',
      for (final e in images) '-i $e',
      '-filter_complex',
      '"${texts.map((e) => '$e;').join(' ')} ${'[${prefixs.last}]'}[1:v]overlay=(W-w)/2:(H-h)/2"',
      output.path,
      '-y'
    ];

    await ffmpeg.execute(cmd);
  }
}
