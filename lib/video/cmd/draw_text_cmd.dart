import 'dart:ui';

import 'package:moviepy_flutter/moviepy_flutter.dart';

String drawtextCMD(
  String text, {
  required Color fontcolor,
  required int fontsize,
  required String position,
  required String fontfile,
  Color? bgcolor,
  int? start,
  int? end,
  int? rotate,
}) {
  var cmd = <String>[
    "text='$text'",
    'fontcolor=${fontcolor.toHex}',
    'fontsize=$fontsize',
    position,
    "fontfile='$fontfile'",
  ];

  if (bgcolor != null) {
    cmd.addAll(['box=1', 'boxcolor=${bgcolor.toHex}']);
  }

  if (start != null && end != null) {
    cmd.add("enable='between(t,$start,$end)'");
  }

  if (rotate != null) cmd.add('rotate=$rotate');

  cmd = cmd.toSet().toList();

  return 'drawtext=${cmd.join(':')}';
}
