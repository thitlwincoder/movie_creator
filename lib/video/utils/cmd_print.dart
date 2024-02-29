import 'dart:developer';

void cmdPrint(String cmd) {
  final buffer = StringBuffer();

  final list = RegExp(r'-(\S{1,4}) ((".+")|(\S+))').allMatches(cmd);

  for (final e in list) {
    final key = '-${e.group(1)}';
    var value = e.group(0)!.split(key).join().trim();

    final v = value.split(':');

    final vB = StringBuffer();

    for (var i = 0; i < v.length; i++) {
      var e = v[i];

      final eB = StringBuffer();

      if (e.contains('=')) {
        final eL = e.split('=');
        if (eL.length > 1) {
          eB
            ..writeln(eL.first)
            ..write('     ${eL.skip(1).join(' ')}');
        } else {
          eB.write(eL.first);
        }
      }

      e = eB.toString();

      // final eB = StringBuffer();

      // for (final e in RegExp(r'(\S)=(\S.*)=').allMatches(e)) {
      //   eB.write(e.group(0));
      // }

      // e = eB.toString();

      // final eB = StringBuffer();

      // final equ = e.split('=');

      // if (equ.length > 1) {
      //   for (final e in equ) {
      //     eB.write(e);
      //   }
      // }

      // e = eB.toString();

      i == 0 ? vB.writeln(e) : vB.writeln('   $e');
    }

    value = vB.toString();

    buffer.write('$key $value');
  }

  log(buffer.toString());
}
