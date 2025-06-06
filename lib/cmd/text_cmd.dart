import 'package:flutter/widgets.dart';
import 'package:movie_creator/movie_creator.dart';
import 'package:movie_creator/utils/temp.dart';

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
    String? fontFile;

    if (this.fontFile != null) {
      fontFile = this.fontFile!.path;

      if (this.fontFile!.type == FileType.file) {
        fontFile = await moveAssetToTemp(fontFile);
      }
    }

    return DrawText(
      text: text,
      rotate: rotate,
      boxColor: bgcolor,
      fontSize: fontsize,
      x: x ?? '(W-tw)/2',
      y: y ?? '(H-th)/2',
      fontFile: fontFile,
      fontColor: fontcolor,
      box: bgcolor != null,
    ).toString();
  }
}
