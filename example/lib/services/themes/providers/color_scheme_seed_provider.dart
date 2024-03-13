import 'package:flutter/material.dart' show Color;


extension HexToColor on String {
  Color hexToColor() {
    return Color(int.parse(replaceFirst('#', '0xFF')));
  }
}
