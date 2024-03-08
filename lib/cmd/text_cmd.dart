import 'package:flutter/widgets.dart';
import 'package:movie_flutter/movie_flutter.dart';

class TextCmd {
  TextCmd(
    this.text, {
    required this.fontsize,
    required this.fontcolor,
    this.x,
    this.y,
    this.rotate,
    this.bgcolor,
    this.start,
    this.end,
  });

  final String text;
  final int fontsize;
  final Color fontcolor;

  final int? x;
  final int? y;

  final int? rotate;

  final Color? bgcolor;

  final int? start;
  final int? end;

  @override
  String toString() {
    final buffer = StringBuffer(
      "drawtext=text='$text':fontsize=$fontsize:fontcolor=${fontcolor.toHex}:",
    );

    if (x != null) buffer.write('x=$x:');
    if (y != null) buffer.write('y=$y:');
    if (rotate != null) buffer.write('rotate=$y*PI/180:');
    if (bgcolor != null) buffer.write('box=1:boxcolor=${bgcolor!.toHex}:');

    if (start != null && end != null) {
      buffer.write("enable='between(t,$start,$end)':");
    }

    return buffer.toString();
  }
}
