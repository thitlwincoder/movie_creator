import 'package:flutter/material.dart';

extension SizeExtension on BuildContext {
  Size get size => MediaQuery.of(this).size;

  double get height => size.height;
  double get width => size.width;
}
