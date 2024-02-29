import 'dart:ui';

import 'package:movie_flutter/movie_flutter.dart';

String colorCMD({
  Color? color,
  Size? size,
  int? rate,
}) {
  final cmd = <String>[];

  if (color != null) cmd.add('c=${color.toHex}');
  if (size != null) cmd.add('s=${size.width.toInt()}x${size.height.toInt()}');
  if (rate != null) cmd.add('r=$rate');

  return 'color=${cmd.join(':')}';
}
