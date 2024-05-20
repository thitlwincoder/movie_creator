import 'package:flutter/material.dart';
import 'package:movie_creator/generators/text_generator/text_generator.dart';
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

  int? x;
  int? y;

  Color color;
  Color bgColor;

  String? fontFamily;
  FontFile? fontFile;

  // Text Styles
  // -  Choose from various pre-defined text styles (bold, italic, underline).
  // -  Apply different fonts and font sizes.

  // Text Alignment:
  // -  Align text left, center, right, or justify

  // Letter and Line Spacing:
  // -  Adjust the spacing between letters and lines for better readability.

  // Text Effects:
  // -  Apply shadows, outlines, and glows to text.
  // -  Create 3D text effects.

  // Text Warp:
  // -  Distort and warp text to fit a particular shape or curve.

  // Text Opacity:
  // -  Adjust the transparency of text for a subtle or watermark effect.

  // Text Background:
  // -  Add background shapes or color behind text for emphasis.
  // -  Apply gradients or textures to text backgrounds.

  // Text Merge with Images:
  // -  Blend text seamlessly with images.
  // -  Use images as fill for text.

  // Text Masking:
  // -  Use images or shapes to mask or clip text.

  // Text Rotation:
  // -  Rotate text at different angles.
  // -  Flip text horizontally or vertically.

  void glow() {
    TextGenerator.instance.glow(
      'input',
      DrawText(
        x: x,
        y: y,
        text: text,
        fontColor: color,
        font: fontFamily,
        boxColor: bgColor,
        fontSize: fontSize,
        fontFile: fontFile?.path,
        start: start,
        end: end,
      ),
    );
  }

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
        '"${[for (final e in textLayers) await getCMD(e, fonts)].join(',')}"'
      ]);
    } else {
      cmd.addAll(['-vf', '"${await getCMD(textLayers.first, fonts)}"']);
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
      x: e.x?.toDouble(),
      y: e.y?.toDouble(),
      fontFile: fontFile,
    ).toFutureString();
  }
}
