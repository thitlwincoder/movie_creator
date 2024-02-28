import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffprobe_kit.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';

class VideoFileClip extends VideoClip {
  VideoFileClip(
    this.media, {
    this.layers,
    this.trim,
  });

  String? frameRate;
  String? aspectRatio;

  int? height;
  int? width;

  String? timeBase;
  String? codecType;

  String? startTime;
  Duration? endTime;
  String? size;

  final File media;

  final Trim? trim;

  final List<TextClip>? layers;

  Future<void> init() async {
    final session = await FFprobeKit.getMediaInformation(media.path);

    final info = session.getMediaInformation()!;

    final json = info.getAllProperties() ?? {};

    final streams = json['streams'] as List;
    final stream = streams.first as Map;

    frameRate = stream['r_frame_rate'] as String?;
    aspectRatio = stream['display_aspect_ratio'] as String?;

    height = stream['height'] as int?;
    width = stream['width'] as int?;

    timeBase = stream['time_base'] as String?;
    codecType = stream['codec_type'] as String?;

    final format = json['format'] as Map;

    super.duration =
        Duration(seconds: double.parse('${format['duration']}').toInt());
    startTime = format['start_time'] as String?;
    endTime = duration;
    size = format['size'] as String?;
  }

  @override
  Future<String> save() async {
    return media.path;
  }

  @override
  Future<void> writeVideoFile(File output) async {
    final file = await setFontDirectory();

    if (super.duration == null) await init();

    final cmd = [
      '-i',
      media.path,
      if (layers?.isNotEmpty ?? false) ...[
        '-vf',
        '"${layers!.map((e) => e.getDrawtextCMD(file, output)).join(', ')}"',
      ],
      if (trim != null && trim?.start != Duration.zero && trim?.end != null)
        subclipCMD(start: trim!.start, end: trim!.end, fromStart: true),
      '-c:a',
      'copy',
      output.path,
      '-y'
    ];

    await ffmpeg.execute(cmd);
  }
}
