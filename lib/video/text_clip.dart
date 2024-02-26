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
    required Size size,
    Color color = Colors.black,
    Color bgColor = Colors.transparent,
    TextStyle? textStyle,
    TextAlign align = TextAlign.center,
  }) : super(File('path'));

  final String text;

  @override
  Future<void> writeVideoFile(File output) async {
    // final cmd = [
    //   '-f',
    //   'lavfi',
    //   '-i',
    //   'color=size=320x240:duration=10:rate=25:color=blue',
    //   '-vf',
    //   'drawtext=fontsize=30:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2:text=$text',
    //   'Overflow',
    //   output.path
    // ];

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

    final cmd = [
      '-f',
      'lavfi',
      '-i',
      'color=c=black:s=640x480:r=30',
      '-vf',
      "drawtext=text='Hello World':fontcolor=white:fontsize=24:x=(w-text_w)/2:y=(h-text_h)/2:fontfile=${file.path}",
      '-t',
      '10',
      output.path,
      '-y'
    ];

    await ffmpeg.execute(cmd);
  }
}
