import 'package:flutter/widgets.dart';
import 'package:movie_flutter/movie_flutter.dart';

String drawtextCMD(
  String text, {
  required Color fontcolor,
  required int fontsize,
  required String fontfile,
  EdgeInsets padding = EdgeInsets.zero,
  Alignment alignment = Alignment.center,
  Color? bgcolor,
  int? start,
  int? end,
  int? rotate,
  String? alpha,
}) {
  var cmd = <String>[
    "text='$text'",
    'fontcolor=${fontcolor.toHex}',
    'fontsize=$fontsize',
    _getPositions(padding, alignment),
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

String _getPositions(EdgeInsets padding, Alignment align) {
  final t = padding.top.toInt();
  final b = padding.bottom.toInt();
  final l = padding.left.toInt();
  final r = padding.right.toInt();

  if (align.x > 1 || align.y > 1) {
    return 'x=${align.x}:y=${align.y}';
  }

  if (align == Alignment.topLeft) return 'x=$l:y=$t';
  if (align == Alignment.topCenter) return 'x=(w-text_w)/2:y=$t';
  if (align == Alignment.topRight) return 'x=w-tw-$r:y=$t';
  if (align == Alignment.bottomLeft) return 'x=$l:y=h-th-$b';
  if (align == Alignment.bottomCenter) return 'x=(w-text_w)/2:y=h-th-$b';
  if (align == Alignment.bottomRight) return 'x=w-tw-$r:y=h-th-$b';

  return 'x=(w-text_w)/2:y=(h-text_h)/2';
}
