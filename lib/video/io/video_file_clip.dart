import 'package:ffmpeg_kit_flutter_full/ffprobe_kit.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';

class VideoFileClip extends VideoClip {
  VideoFileClip(super.media);

  String? frameRate;
  String? aspectRatio;

  int? height;
  int? width;

  String? timeBase;
  String? codecType;

  String? duration;
  String? startTime;
  String? endTime;
  String? size;

  Future<void> init() async {
    final session = await FFprobeKit.getMediaInformation(media.path);

    final info = session.getMediaInformation()!;

    final json = info.getAllProperties() ?? {};

    final streams = json['streams'] as List;
    final stream = streams.first as Map<String, dynamic>;

    frameRate = stream['r_frame_rate'] as String?;
    aspectRatio = stream['display_aspect_ratio'] as String?;

    height = stream['height'] as int?;
    width = stream['width'] as int?;

    timeBase = stream['time_base'] as String?;
    codecType = stream['codec_type'] as String?;

    final formats = json['format'] as List;
    final format = formats.first as Map<String, dynamic>;

    duration = format['duration'] as String?;
    startTime = format['start_time'] as String?;
    endTime = duration;
    size = format['size'] as String?;
  }
}
