import 'dart:io';
import 'dart:ui';

import 'package:moviepy_flutter/moviepy_flutter.dart'
    show ColorExt, ImageClip, ffmpeg;

class ColorClip extends ImageClip {
  ColorClip(
    this.color, {
    required this.duration,
    this.rate = 30,
    this.size = const Size(320, 240),
  }) : super(File('path'));

  final Color color;
  final Size size;
  final int rate;
  final Duration duration;

  @override
  Future<void> writeVideoFile(File output) async {
    final sizeFormat = '${size.width.toInt()}x${size.height.toInt()}';

    final cmd = [
      'f',
      'lavfi',
      '-i',
      'color='
          'c=${color.toHex}:'
          's=$sizeFormat:'
          'r=$rate',
      '-t',
      '${duration.inSeconds}',
    ];
    await ffmpeg.execute(cmd);
  }
}
