import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_creator/core/core.dart';
import 'package:movie_creator/filters/filter.dart';

class DrawText extends Filter {
  DrawText({
    this.text,
    this.box,
    this.boxBorderW,
    this.boxColor,
    this.lineSpacing,
    this.textAlign,
    this.borderW,
    this.borderColor,
    this.expansion,
    this.fontColor,
    this.fontColorExpr,
    this.font,
    this.fontFile,
    this.alpha,
    this.fontSize,
    this.textShaping,
    this.shadowColor,
    this.boxW,
    this.boxH,
    this.shadowX,
    this.shadowY,
    this.startNumber,
    this.tabSize,
    this.textfile,
    this.x,
    this.y,
    this.duration,
    this.start,
    this.end,
  });

  String? text;
  bool? box;
  BoxBorderWidth? boxBorderW;
  Color? boxColor;
  int? lineSpacing;
  TextAlign? textAlign;
  int? borderW;
  Color? borderColor;
  Expansion? expansion;
  Color? fontColor;
  String? fontColorExpr;
  String? font;
  String? fontFile;
  String? alpha;
  int? fontSize;
  int? textShaping;
  Color? shadowColor;
  int? boxW;
  int? boxH;
  int? shadowX;
  int? shadowY;
  int? startNumber;
  int? tabSize;
  String? textfile;
  int? x;
  int? y;
  int? duration;
  int? start;
  int? end;

  @override
  String toString() {
    final cmd = <String, dynamic>{};

    cmd['box'] = (box ?? false) ? 1 : 0;
    cmd['boxborderw'] = boxBorderW?.toBoxBorderWidth() ?? 0;
    cmd['boxcolor'] = boxColor?.toHex;
    cmd['line_spacing'] = lineSpacing;
    cmd['text_align'] = textAlign?.name;
    cmd['borderw'] = borderW;
    cmd['bordercolor'] = borderColor?.toHex;
    cmd['fontcolor'] = fontColor?.toHex;
    cmd['fontcolor_expr'] = fontColorExpr;
    cmd['font'] = font;
    cmd['fontfile'] = fontFile;
    cmd['alpha'] = alpha;
    cmd['fontsize'] = fontSize;
    cmd['text_shaping'] = textShaping;
    cmd['shadowcolor'] = shadowColor?.toHex;
    cmd['boxw'] = boxW;
    cmd['boxh'] = boxH;
    cmd['shadowx'] = shadowX;
    cmd['shadowy'] = shadowY;
    cmd['start_number'] = startNumber;
    cmd['tabsize'] = tabSize;
    cmd['text'] = text;
    cmd['textfile'] = textfile;
    cmd['x'] = x;
    cmd['y'] = y;
    cmd['duration'] = duration;

    if (start != null || end != null) {
      cmd['enable'] = 'between(t,${start ?? 0},${end ?? 'inf'})';
    }

    cmd.removeWhere((key, value) => value == null);

    final str = cmd.keys.map((e) => '$e=${jsonEncode(cmd[e])}').join(':');

    return 'drawtext=$str';
  }
}

enum Expansion { none, strftime, normal }

class BoxBorderWidth {
  BoxBorderWidth({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  factory BoxBorderWidth.all(int width) => BoxBorderWidth(
        top: width,
        bottom: width,
        left: width,
        right: width,
      );

  factory BoxBorderWidth.symmetric({int? vertical, int? horizontal}) =>
      BoxBorderWidth(
        top: vertical,
        bottom: vertical,
        left: horizontal,
        right: horizontal,
      );

  final int? top;
  final int? bottom;
  final int? left;
  final int? right;

  String toBoxBorderWidth() {
    final list = [top, right, bottom, left]..remove(null);

    if (top == bottom && left == right) return '$top|$right';

    return list.join('|');
    // return '$top|$right|$bottom|$left';
  }
}
