import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:flutter/material.dart' show Alignment, Colors, EdgeInsets;
import 'package:flutter/services.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';
import 'package:moviepy_flutter/video/cmd/color_cmd.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class TextClip extends ImageClip {
  TextClip(
    this.text, {
    this.duration,
    this.style,
    this.rate = 30,
    this.padding = EdgeInsets.zero,
    this.size,
    this.color = Colors.transparent,
    this.background,
  }) {
    style ??= TextClipStyle();
  }

  final String text;
  final Size? size;
  final int rate;
  final Color color;
  final Duration? duration;
  TextClipStyle? style;
  final EdgeInsets padding;
  final Clip? background;

  String getDrawtextCMD(File fontfile, File output) {
    final position = _getPositions();

    return drawtextCMD(
      text,
      position: position,
      fontfile: fontfile.path,
      end: style?.end?.inSeconds,
      start: style?.start?.inSeconds,
      fontsize: style?.fontSize ?? 24,
      bgcolor: style?.backgroundColor,
      fontcolor: style?.color ?? Colors.white,
    );
  }

  @override
  Future<void> writeVideoFile(File output) async {
    final font = await rootBundle.load('assets/Baloo2-Medium.ttf');
    final docDir = await getApplicationDocumentsDirectory();
    final path = p.join(docDir.path, 'Baloo2-Medium.ttf');
    final file = File(path);

    if (!file.existsSync()) {
      await file.create();
      await file.writeAsBytes(font.buffer.asUint8List(
        font.offsetInBytes,
        font.lengthInBytes,
      ));
    }

    await FFmpegKitConfig.setFontDirectory(file.path);

    final isBgIsVideo = background is VideoFileClip;

    final cmd = [
      if (!isBgIsVideo) ...['-f', 'lavfi'],
      '-i',
      if (isBgIsVideo)
        '"${(background! as VideoFileClip).media.path}"'
      else
        colorCMD(color: color, rate: rate, size: size),
      '-vf',
      getDrawtextCMD(file, output),
      if (duration != null) ...['-t', '${duration!.inSeconds}'],
      if (isBgIsVideo) ...['-c:a', 'copy'],
      output.path,
      '-y'
    ];

    print(cmd);

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
