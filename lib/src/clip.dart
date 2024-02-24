import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moviepy_flutter/core/core.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Clip {
  Clip(this.media);

  final File media;

  Future<MemoryImage> getFrame(Duration position) async {
    final name =
        Platform.isAndroid || Platform.isIOS ? 'image.jpg' : 'image.bmp';

    final dir = await getTemporaryDirectory();

    final temp = File(p.join(dir.path, name));
    await temp.create();

    final cmd = [
      '-an',
      '-ss',
      '${position.inSeconds}',
      '-i',
      media.path.replaceAll(r'\', '/'),
      '-frames:v',
      '1',
      temp.path,
      '-y',
    ];

    await ffmpeg.executeAsync(cmd);

    if (temp.existsSync()) {
      final data = await temp.readAsBytes();
      await temp.delete();

      return MemoryImage(data);
    }

    throw const FailedToGetFrameFromMedia(null);
  }
}
