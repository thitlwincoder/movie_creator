import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class TextClip extends ImageClip {
  TextClip(
    this.text, {
    required this.duration,
    this.rate = 30,
    this.size = const Size(320, 240),
    this.color = Colors.black,
    this.textStyle,
    this.padding,
    this.align = Alignment.center,
  }) : super(File('path'));

  final String text;
  final Color color;
  final Size size;
  final int rate;
  final Duration duration;
  final TextStyle? textStyle;
  final int? padding;
  final Alignment align;

  @override
  Future<void> writeVideoFile(File output) async {
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

    final sizeFormat = '${size.width.toInt()}x${size.height.toInt()}';

    final fontColor = textStyle?.color ?? Colors.white;
    final fontSize = textStyle?.fontSize?.toInt() ?? 24;

    final position = _getPositions(align, padding ?? 0);

    final cmd = [
      '-f',
      'lavfi',
      '-i',
      'color='
          'c=${toHex(color)}:'
          's=$sizeFormat:'
          'r=$rate',
      '-vf',
      'drawtext='
          'text="$text":'
          'fontcolor=${toHex(fontColor)}:'
          'fontsize=$fontSize:'
          '$position:'
          'fontfile=${file.path}',
      '-t',
      '${duration.inSeconds}',
      output.path,
      '-y'
    ];

    await ffmpeg.execute(cmd);
  }
}

String _getPositions(Alignment align, int padding) {
  if (align == Alignment.topLeft) return 'x=$padding:y=$padding';
  if (align == Alignment.topCenter) return 'x=(w-text_w)/2:y=$padding';
  if (align == Alignment.topRight) return 'x=w-tw-$padding:y=$padding';
  if (align == Alignment.bottomLeft) return 'x=$padding:y=h-th-$padding';
  if (align == Alignment.bottomCenter) return 'x=(w-text_w)/2:y=h-th-$padding';
  if (align == Alignment.bottomRight) return 'x=w-tw-$padding:y=h-th-$padding';
  return 'x=(w-text_w)/2:y=(h-text_h)/2';
}

String toHex(Color color) {
  String format(int v) => v.toRadixString(16).padLeft(2, '0');
  return '0x${format(color.red)}${format(color.green)}${format(color.blue)}';
}
