import 'package:flutter/widgets.dart';
import 'package:movie_flutter/movie_flutter.dart';

String drawtextCMD(
  String text, {
  required Color fontcolor,
  required int fontsize,
  EdgeInsets padding = EdgeInsets.zero,
  Alignment alignment = Alignment.center,
  Color? bgcolor,
  int? start,
  int? end,
  int? rotate,
  Effect? effect,
}) {
  // if (effect != null) {
  //   start ??= effect.delay;
  //   end ??= effect.delay + effect.time;
  // }

  final buffer = StringBuffer(
    "drawtext=text='$text':fontsize=$fontsize:",
  );

  if (effect == null) {
    buffer.write('${_getPositions(padding, alignment)}:');
  } else {
    final (x, y) = _getXY(padding, alignment);
    buffer.write('x=$x:y=$y-(t*20)-20:');
  }

  if (bgcolor != null) {
    buffer.write('box=1:boxcolor=${bgcolor.toHex}:');
  }

  if (start != null && end != null) {
    buffer.write("enable='between(t,$start,$end)':");
  }

  // if (effect != null) {
  //   buffer.write(
  //       "alpha='if(lte(t,${effect.delay}),0,if(lte(t,${effect.delay + effect.time}),(t-${effect.delay})/1,1))'");
  // }

  return buffer.toString();
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

(double x, double double) _getXY(EdgeInsets padding, Alignment align) {
  final p = _getPositions(padding, align);

  final s = p.split(':');

  double parse(String str) {
    return double.parse(str.split('=').last);
  }

  final x = parse(s.first);
  final y = parse(s.last);

  return (x, y);
}
