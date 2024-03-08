import 'package:flutter/widgets.dart';
import 'package:movie_flutter/core/core.dart';

class ColorCmd {
  ColorCmd({
    required this.color,
    required this.height,
    required this.width,
    required this.fps,
    required this.duration,
  });

  final Color color;
  final int height;
  final int width;
  final int fps;
  final double? duration;

  @override
  String toString() {
    final buffer = StringBuffer('color=c=${color.toHex}:')
      ..write('s=${width}x$width:')
      ..write('r=$fps:');

    if (duration != null) {
      buffer.write('d=$duration');
    }

    return buffer.toString();
  }
}
