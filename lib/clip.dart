import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moviepy_flutter/core/core.dart';

class Clip {
  Clip(this.media);

  final File media;

  Future<MemoryImage> getFrame(Duration position) async {
    final file = (Platform.isAndroid || Platform.isIOS)
        ? 'Osumffmpeg Frame.jpg'
        : 'Osumffmpeg Frame.bmp';

    await ffmpeg.execute(
      commands: [
        '-an',
        '-ss',
        '${position.inSeconds}',
        '-i',
        media.path,
        '-frames:v',
        '1',
        file,
        '-y',
      ],
    );

    final thumbnail = File(file);

    if (thumbnail.existsSync()) {
      final data = await thumbnail.readAsBytes();
      await thumbnail.delete();

      return MemoryImage(data);
    }
    throw const FailedToGetFrameFromMedia(null);
  }
}
