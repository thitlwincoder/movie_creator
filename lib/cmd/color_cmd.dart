import 'package:flutter/widgets.dart';
import 'package:movie_creator/core/core.dart';

/// color cmd
class ColorCmd {
  ColorCmd({
    required this.color,
    required this.height,
    required this.width,
    required this.fps,
    required this.duration,
  });

  /// color
  final Color color;

  /// height
  final int height;

  /// width
  final int width;

  /// fps
  final int? fps;

  /// duration
  final double? duration;

  @override
  String toString() {
    /// use `StringBuffer` to add string
    final buffer = StringBuffer('color=c=${color.toHex}:')

      /// set height & width value
      ..write('s=${width}x$width:');

    /// set `fps` value
    if (fps != null) buffer.write('r=$fps:');

    /// set `duration` value
    if (duration != null) {
      buffer.write('d=$duration');
    }

    return buffer.toString();
  }
}
