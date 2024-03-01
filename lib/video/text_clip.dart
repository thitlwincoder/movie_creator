import 'dart:io';

import 'package:flutter/material.dart' show Alignment, Colors, EdgeInsets;
import 'package:flutter/services.dart';
import 'package:movie_flutter/movie_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class TextClip extends Clip {
  TextClip(
    this.text, {
    this.effect,
    Duration? duration,
    this.rate = 30,
    Size? size,
    this.start,
    this.end,
    this.rotate,
    this.color,
    this.fontSize,
    this.backgroundColor,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
  }) {
    if (duration != null) super.duration = duration;
    if (size != null) super.size = size;
  }

  final String text;
  final int rate;
  final EdgeInsets padding;
  final int? rotate;
  final Alignment alignment;

  final int? start;
  final int? end;

  final Color? color;
  final Color? backgroundColor;
  final int? fontSize;
  final Effect? effect;

  String getDrawtextCMD(File output) {
    return drawtextCMD(
      text,
      end: end,
      start: start,
      rotate: rotate,
      padding: padding,
      alignment: alignment,
      fontsize: fontSize ?? 24,
      bgcolor: backgroundColor,
      fontcolor: color ?? Colors.white,
    );
  }

  @override
  Future<String> save() async {
    await setFontDirectory();

    final temp = await getTemporaryDirectory();
    final output = p.join(temp.path, '${DateTime.now().millisecond}.mp4');

    final cmd = [
      '-f',
      'lavfi',
      '-vf',
      getDrawtextCMD(File(output)),
      ...['-t', '${super.duration}'],
      output,
      '-y'
    ];

    await ffmpeg.execute(cmd);

    return output;
  }

  @override
  Future<void> writeVideoFile(File output) async {
    final temp = await save();
    await File(temp).copy(output.path);
    await File(temp).delete();
  }
}
