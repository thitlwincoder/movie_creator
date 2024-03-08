import 'package:flutter/material.dart';
import 'package:movie_creator/movie_creator.dart';

class TextLayer extends Layer {
  TextLayer(
    this.text, {
    this.fontSize = 20,
    this.start,
    this.end,
    this.rotate,
    this.x,
    this.y,
    this.color = Colors.white,
    this.bgColor = Colors.black,
  });

  final String text;

  int fontSize;

  int? rotate;

  int? start;
  int? end;

  int? x;
  int? y;

  Color color;
  Color bgColor;

  static Future<bool> export(
    List<TextLayer> textLayers,
    String input,
    String output,
  ) {
    final cmd = <String>['-i', '"$input"'];

    if (textLayers.length > 1) {
      cmd.addAll([
        '-filter_complex',
        [
          for (final e in textLayers) '${getCMD(e)}',
        ].join(',')
      ]);
    } else {
      cmd.addAll([
        '-vf',
        '${getCMD(textLayers.first)}',
      ]);
    }

    cmd.addAll(['-c:a', 'copy', '"$output"', '-y']);

    return ffmpeg.execute(cmd);
  }

  static TextCmd getCMD(TextLayer e) {
    return TextCmd(
      e.text,
      fontcolor: e.color,
      fontsize: e.fontSize,
      start: e.start,
      end: e.end,
      bgcolor: e.bgColor,
      rotate: e.rotate,
      x: e.x,
      y: e.y,
    );
  }
}
