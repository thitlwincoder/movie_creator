enum TransitionType {
  fade,
  wipeleft,
  wiperight,
  wipeup,
  wipedown,
  slideleft,
  slideright,
  slideup,
  slidedown,
  circlecrop,
  rectcrop,
  distance,
  fadeblack,
  fadewhite,
  radial,
  smoothleft,
  smoothright,
  smoothup,
  smoothdown,
  circleopen,
  circleclose,
  vertopen,
  vertclose,
  horzopen,
  horzclose,
  dissolve,
  pixelize,
  diagtl,
  diagtr,
  diagbl,
  diagbr,
  hlslice,
  hrslice,
  vuslice,
  vdslice,
  hblur,
  fadegrays,
  wipetl,
  wipetr,
  wipebl,
  wipebr,
  squeezeh,
  squeezev,
  zoomin,
  fadefast,
  fadeslow,
  hlwind,
  hrwind,
  vuwind,
  vdwind,
  coverleft,
  coverright,
  coverup,
  coverdown,
  revealleft,
  revealright,
  revealup,
  revealdown;

  @override
  String toString() => name;
}

class Transition {
  Transition({
    this.type = TransitionType.fade,
    this.duration = 1,
  });

  final TransitionType type;
  final int duration;
  int? offset;

  @override
  String toString() {
    final buffer = StringBuffer('xfade=transition=$type:duration=$duration');

    if (offset != null) {
      buffer.write(':offset=$offset');
    }

    return buffer.toString();
  }

  int setOffset(int duration, [int previousOffset = 0]) {
    offset = duration + previousOffset - this.duration;

    return offset!;
  }

  // input duration   +   previous xfade offset  -    xfade duration    offset
  // 4                    0                           1                 3
  // 8                    3                           1                 10
  // 12                   10                          1                 21
  // 5                    21                          1                 25
}
