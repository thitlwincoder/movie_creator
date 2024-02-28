import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextClipStyle {
  TextClipStyle({
    this.backgroundColor,
    this.color,
    this.fontSize,
  
    this.alignment = Alignment.center,
  });

  final Color? color;
  final Color? backgroundColor;
  final int? fontSize;
  final Alignment alignment;
}
