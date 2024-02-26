import 'dart:ui';

import 'package:moviepy_flutter/moviepy_flutter.dart';

String drawtext(
  String text, {
  required Color fontcolor,
  required int fontsize,
  required String position,
  required String fontfile,
  Color? bgcolor,
}) {
  var cmd = <String>[
    'text="$text"',
    'fontcolor=${fontcolor.toHex}',
    'fontsize=$fontsize',
    position,
    'fontfile=$fontfile',
  ];

  if (bgcolor != null) {
    cmd.addAll([
      'box=1',
      'boxcolor=${bgcolor.toHex}',
    ]);
  }

  cmd = cmd.toSet().toList();

  return 'drawtext=${cmd.join(':')}';
}
