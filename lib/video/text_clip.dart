import 'dart:io';

import 'package:flutter/material.dart' show Alignment, Colors, EdgeInsets;
import 'package:flutter/services.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class TextClip extends ImageClip {
  TextClip(
    this.text, {
    Duration? duration,
    this.style,
    this.rate = 30,
    this.size,
    this.start,
    this.end,
    this.rotate,
    this.padding = EdgeInsets.zero,
    this.color = Colors.transparent,
  }) {
    style ??= TextClipStyle();
    super.duration = duration;
  }

  final String text;
  final Size? size;
  final int rate;
  final Color color;
  TextClipStyle? style;
  final EdgeInsets padding;
  final int? rotate;

  final Duration? start;
  final Duration? end;

  String getDrawtextCMD(File fontfile, File output) {
    final position = _getPositions();

    return drawtextCMD(
      text,
      rotate: rotate,
      position: position,
      fontfile: fontfile.path,
      end: end?.inSeconds,
      start: start?.inSeconds,
      fontsize: style?.fontSize ?? 24,
      bgcolor: style?.backgroundColor,
      fontcolor: style?.color ?? Colors.white,
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
      '-i',
      colorCMD(color: color, rate: rate, size: size),
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

  String _getPositions() {
    final t = padding.top.toInt();
    final b = padding.bottom.toInt();
    final l = padding.left.toInt();
    final r = padding.right.toInt();

    final align = style?.alignment;

    if (align == Alignment.topLeft) return 'x=$l:y=$t';
    if (align == Alignment.topCenter) return 'x=(w-text_w)/2:y=$t';
    if (align == Alignment.topRight) return 'x=w-tw-$r:y=$t';
    if (align == Alignment.bottomLeft) return 'x=$l:y=h-th-$b';
    if (align == Alignment.bottomCenter) return 'x=(w-text_w)/2:y=h-th-$b';
    if (align == Alignment.bottomRight) return 'x=w-tw-$r:y=h-th-$b';

    return 'x=(w-text_w)/2:y=(h-text_h)/2';
  }
}
