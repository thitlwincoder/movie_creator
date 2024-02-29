import 'dart:io';

import 'package:flutter/material.dart' show Alignment, Colors, EdgeInsets;
import 'package:flutter/services.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class TextClip extends Clip {
  TextClip(
    this.text, {
    Effect? effect,
    Duration? duration,
    this.rate = 30,
    this.size,
    this.start,
    this.end,
    this.rotate,
    this.color,
    this.fontSize,
    this.backgroundColor,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
  }) {
    super.duration = duration;
  }

  final String text;
  final Size? size;
  final int rate;
  final EdgeInsets padding;
  final int? rotate;
  final Alignment alignment;

  final Duration? start;
  final Duration? end;

  final Color? color;
  final Color? backgroundColor;
  final int? fontSize;

  String getDrawtextCMD(File fontfile, File output) {
    return drawtextCMD(
      text,
      rotate: rotate,
      padding: padding,
      end: end?.inSeconds,
      alignment: alignment,
      start: start?.inSeconds,
      fontfile: fontfile.path,
      fontsize: fontSize ?? 24,
      bgcolor: backgroundColor,
      fontcolor: color ?? Colors.white,
    );
  }

  @override
  Future<String> save() async {
    final file = await setFontDirectory();

    final temp = await getTemporaryDirectory();
    final output = p.join(temp.path, '${DateTime.now().millisecond}.mp4');

    final cmd = [
      '-f',
      'lavfi',
      // '-i',
      // colorCMD(color: color, rate: rate, size: size),
      '-vf',
      getDrawtextCMD(file, File(output)),
      if (super.duration != null) ...['-t', '${super.duration}'],
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
