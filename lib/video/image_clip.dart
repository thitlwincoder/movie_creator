import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:movie_flutter/movie_flutter.dart'
    show Clip, Transition, VideoClip;
import 'package:movie_flutter/video/utils/effect.dart';

class ImageClip extends Clip {
  ImageClip({
    required this.path,
    required this.alignment,
    this.padding,
    double? scale,
    Effect? effect,
    Duration? duration,
    this.transition,
  });

  final String path;
  final EdgeInsets? padding;
  final Alignment alignment;
  final Transition? transition;

  @override
  Future<void> writeVideoFile(File output) async {}

  @override
  String getPositions(
    Alignment align, [
    EdgeInsets? padding,
    Transition? transition,
  ]) {
    // if (transition == Transition.shake) {
    //   return "x='if(lte(mod(t,2),1),random(10)*10,0)':y='if(lte(mod(t,2),1),random(10)*10,0)'";
    // }

    padding ??= EdgeInsets.zero;

    final t = padding.top.toInt();
    final b = padding.bottom.toInt();
    final l = padding.left.toInt();
    final r = padding.right.toInt();

    if (align.x > 1 || align.y > 1) {
      return 'x=${align.x}:y=${align.y}';
    }

    if (align == Alignment.topLeft) return 'x=$l:y=$t';
    if (align == Alignment.topCenter) return 'x=(main_w-overlay_w)/2:y=$t';
    if (align == Alignment.topRight) return 'x=main_w-overlay_w-$r:y=$t';
    if (align == Alignment.bottomLeft) return 'x=$l:y=main_h-overlay_h-$b';
    if (align == Alignment.bottomCenter) {
      return 'x=(main_w-overlay_w)/2:y=main_h-overlay_h-$b';
    }
    if (align == Alignment.bottomRight) {
      return 'x=main_w-overlay_w-$r:y=main_h-overlay_h-$b';
    }

    return 'x=(main_w-overlay_w)/2:y=(main_h-overlay_h)/2';
  }
}
