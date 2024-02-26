import 'dart:ui';

String toHex(Color color) {
  String format(int v) => v.toRadixString(16).padLeft(2, '0');
  return '0x${format(color.red)}${format(color.green)}${format(color.blue)}';
}
