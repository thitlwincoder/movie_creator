import 'package:flutter/widgets.dart';
import 'package:movie_creator/movie_creator.dart';

class FontFile {
  FontFile.asset(this.path) : type = FileType.asset;
  FontFile.file(this.path) : type = FileType.file;

  final String path;
  final FileType type;
}

/// text cmd
class TextCmd {
  TextCmd(
    this.text, {
    required this.fontsize,
    required this.fontcolor,
    this.x,
    this.y,
    this.rotate,
    this.bgcolor,
    this.start,
    this.end,
    this.fontFile,
  });

  /// string text
  final String text;

  /// font size
  final int fontsize;

  /// font color
  final Color fontcolor;

  /// x position
  final double? x;

  /// y position
  final double? y;

  /// rotate in degree
  final int? rotate;

  /// background color
  final Color? bgcolor;

  /// start duration in sec
  final int? start;

  /// end duration in sec
  final int? end;

  /// font file
  final FontFile? fontFile;

  Future<String> toFutureString() async {
    /// use `StringBuffer` to add string
    final buffer = StringBuffer(
      'drawtext=text="$text":fontsize=$fontsize:fontcolor=${fontcolor.toHex}:',
    );

    /// set `x` position
    if (x != null) buffer.write('x=$x:');

    /// set `y` position
    if (y != null) buffer.write('y=$y:');

    /// set `rotate` value
    if (rotate != null) buffer.write('rotate=$y*PI/180:');

    /// set `bgcolor` value
    if (bgcolor != null) buffer.write('box=1:boxcolor=${bgcolor!.toHex}:');

    /// set start and end duration
    if (start != null || end != null) {
      buffer.write('enable="between(t,${start ?? 0},${end ?? 'inf'})"');
    }

    if (fontFile != null) {
      var path = fontFile!.path;

      if (fontFile!.type == FileType.file) {
        path = await moveAssetToTemp(path);
      }

      buffer.write('fontfile="$path"');
    }

    return buffer.toString();
  }
}
