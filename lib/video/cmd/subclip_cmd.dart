String subclipCMD({
  Duration? start,
  Duration? end,
  bool fromStart = false,
}) {
  var cmd = '';

  if (start != null) cmd += '-ss $start';

  if (end != null) {
    start ??= Duration.zero;

    final t = !fromStart ? end : end - start;

    cmd += '-t $t';
  }

  return cmd;
}
