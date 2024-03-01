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
    this.offset = 0,
  });

  final TransitionType type;
  final int duration;
  final int offset;

  @override
  String toString() {
    return 'xfade=transition=$type:duration=$duration:offset=$offset';
  }
}
