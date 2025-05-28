import 'dart:ui';

extension ColorExt on Color {
  String get toHex {
    String format(int v) => v.toRadixString(16).padLeft(2, '0');
    return '''
0x${format(_floatToInt8(r))}${format(_floatToInt8(g))}${format(_floatToInt8(b))}
''';
  }

  int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}
