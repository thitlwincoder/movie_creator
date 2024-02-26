import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:flutter/material.dart' show Alignment, Colors, EdgeInsets;
import 'package:flutter/services.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class TextClip extends ImageClip {
  TextClip(
    this.text, {
    required this.duration,
    this.style,
    this.rate = 30,
    this.padding = EdgeInsets.zero,
    this.size = const Size(720, 480),
    this.color = Colors.transparent,
  }) : super(File('path')) {
    style ??= TextClipStyle();
  }

  final String text;
  final Size size;
  final int rate;
  final Color color;
  final Duration duration;
  TextClipStyle? style;
  final EdgeInsets padding;

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

    final position = _getPositions();

    // final drawtext = 'drawtext='
    //     'text="$text":'
    //     'fontcolor=${fontcolor.toHex}:'
    //     'fontsize=$fontSize:'
    //     '$position:'
    //     'fontfile=${file.path}:'
    //     'box=1:'
    //     'boxcolor=${Colors.red.toHex}';

    final cmd = [
      '-f',
      'lavfi',
      '-i',
      'color='
          'c=${color.toHex}:'
          's=$sizeFormat:'
          'r=$rate',
      '-vf',
      drawtext(
        text,
        fontcolor: style?.color ?? Colors.white,
        fontsize: style?.fontSize ?? 24,
        position: position,
        fontfile: file.path,
        bgcolor: style?.backgroundColor,
      ),
      '-t',
      '${duration.inSeconds}',
      output.path,
      '-y'
    ];

    await ffmpeg.execute(cmd);
  }

  String _getPositions() {
    final t = padding.top.toInt();
    final b = padding.bottom.toInt();
    final l = padding.left.toInt();
    final r = padding.right.toInt();

    final align = style?.align;

    if (align == Alignment.topLeft) return 'x=$l:y=$t';
    if (align == Alignment.topCenter) return 'x=(w-text_w)/2:y=$t';
    if (align == Alignment.topRight) return 'x=w-tw-$r:y=$t';
    if (align == Alignment.bottomLeft) return 'x=$l:y=h-th-$b';
    if (align == Alignment.bottomCenter) return 'x=(w-text_w)/2:y=h-th-$b';
    if (align == Alignment.bottomRight) return 'x=w-tw-$r:y=h-th-$b';

    return 'x=(w-text_w)/2:y=(h-text_h)/2';
  }
}
