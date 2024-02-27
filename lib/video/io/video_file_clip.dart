import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full/ffprobe_kit.dart';
import 'package:flutter/services.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class VideoFileClip extends VideoClip {
  VideoFileClip(
    this.media, {
    this.clips = const [],
  });

  String? frameRate;
  String? aspectRatio;

  int? height;
  int? width;

  String? timeBase;
  String? codecType;

  double? duration;
  String? startTime;
  double? endTime;
  String? size;

  final File media;

  final List<TextClip> clips;

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

    duration = double.parse('${format['duration']}');
    startTime = format['start_time'] as String?;
    endTime = duration;
    size = format['size'] as String?;
  }

  @override
  Future<void> writeVideoFile(File output) async {
    final font = await rootBundle.load('assets/Baloo2-Medium.ttf');
    final docDir = await getApplicationDocumentsDirectory();
    final path = p.join(docDir.path, 'Baloo2-Medium.ttf');
    final file = File(path);
    await file.create();
    await file.writeAsBytes(font.buffer.asUint8List(
      font.offsetInBytes,
      font.lengthInBytes,
    ));

    await FFmpegKitConfig.setFontDirectory(file.path);

    final cmd = [
      '-i',
      media.path,
      '-vf',
      '"${clips.map((e) => e.getDrawtextCMD(file, output)).join(', ')}"',
      '-c:a',
      'copy',
      output.path,
      '-y'
    ];

    await ffmpeg.execute(cmd);
  }
}
