import 'package:flutter/material.dart';
import 'package:movie_creator/cmd/text_cmd.dart';
import 'package:movie_creator/filters/draw_text.dart';
import 'package:movie_creator/generators/text_generator/text_generator.dart';
import 'package:movie_creator/layers/text_layer.dart';

class TextLayerImpl implements TextLayer {
  TextLayerImpl(
    this.text, {
    int? fontSize,
    this.start,
    this.end,
    this.rotate,
    this.x,
    this.y,
    Color? color,
    Color? bgColor,
    FontFile? fontFile,
    String? fontFamily,
  })  : _fontFile = fontFile,
        _fontFamily = fontFamily,
        fontSize = fontSize ?? 20,
        color = color ?? Colors.white,
        bgColor = bgColor ?? Colors.black;

  final String text;

  int fontSize;

  int? rotate;

  int? start;
  int? end;

  int? x;
  int? y;

  Color color;
  Color bgColor;

  final String? _fontFamily;
  final FontFile? _fontFile;

  TextGenerator generator = TextGenerator();

  @override
  FontFile? get fontFile => _fontFile;

  @override
  String? get fontFamily => _fontFamily;

  @override
  void glow() {
    generator.glow(
      'input',
      DrawText(
        x: x,
        y: y,
        end: end,
        text: text,
        start: start,
        fontColor: color,
        font: fontFamily,
        boxColor: bgColor,
        fontSize: fontSize,
        fontFile: fontFile?.path,
      ),
    );
  }
}
