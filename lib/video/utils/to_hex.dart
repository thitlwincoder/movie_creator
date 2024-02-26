import 'dart:ui';

extension ColorExt on Color {
  String get toHex {
    String format(int v) => v.toRadixString(16).padLeft(2, '0');
    return '0x${format(red)}${format(green)}${format(blue)}';
  }
}
