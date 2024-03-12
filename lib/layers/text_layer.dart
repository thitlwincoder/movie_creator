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
    this.fontFile,
    this.fontFamily,
  });

  final String text;

  int fontSize;

  int? rotate;

  int? start;
  int? end;

  double? x;
  double? y;

  Color color;
  Color bgColor;

  String? fontFamily;
  FontFile? fontFile;

  static Future<bool> export(
    List<TextLayer> textLayers,
    int? fps,
    String input,
    String output,
    Map<String, FontFile> fonts,
  ) async {
    final cmd = <String>['-i', '"$input"'];

    if (fps != null) cmd.addAll(['-r', '$fps']);

    if (textLayers.length > 1) {
      cmd.addAll([
        '-filter_complex',
        [for (final e in textLayers) await getCMD(e, fonts)].join(',')
      ]);
    } else {
      cmd.addAll(['-vf', await getCMD(textLayers.first, fonts)]);
    }

    cmd.addAll(['-c:a', 'copy', '"$output"', '-y']);

    return ffmpeg.execute(cmd);
  }

  static Future<String> getCMD(TextLayer e, Map<String, FontFile> fonts) {
    var fontFile = e.fontFile;

    if (e.fontFamily != null) {
      fontFile ??= fonts[e.fontFamily];
    }

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
      fontFile: fontFile,
    ).toFutureString();
  }
}
