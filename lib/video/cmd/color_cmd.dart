import 'dart:ui';

import 'package:movie_flutter/movie_flutter.dart';

String colorCMD({
  required Color color,
  Size? size,
  int? rate,
  Duration? duration,
}) {
  final buffer = StringBuffer('color=c=${color.toHex}:');

  if (size != null) {
    final w = size.width.toInt();
    final h = size.height.toInt();
    buffer.write('s=${w}x$h:');
  }

  if (rate != null) buffer.write('r=$rate:');
  if (duration != null) buffer.write('d=${duration.inSeconds}');

  return buffer.toString();
}
