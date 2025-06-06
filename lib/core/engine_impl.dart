import 'dart:io';

import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_minimal/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_minimal/return_code.dart';
import 'package:flutter/services.dart';
import 'package:movie_creator/movie_creator.dart';

class EngineImpl implements Engine {
  EngineImpl(this.execs);

  final Execs execs;

  @override
  Future<bool> execute(List<String> commands) async {
    if (Platform.isAndroid || Platform.isIOS) {
      switch (execs) {
        case Execs.ffmpeg:
          final session = await FFmpegKit.execute(commands.join(' '));
          logger.i(session.getCommand() ?? '');

          final code = await session.getReturnCode();

          if (!ReturnCode.isSuccess(code)) {
            logger.e((await session.getAllLogsAsString()) ?? '');
          }

          return ReturnCode.isSuccess(code);
        case Execs.ffprobe:
          final session = await FFprobeKit.execute(commands.join(' '));
          final code = await session.getReturnCode();
          return ReturnCode.isSuccess(code);
        case Execs.ffplay:
          throw MissingPluginException('FFplay not available.');
      }
    } else {
      final process = await Process.run(execs.name, commands);

      final exitCode = process.exitCode;

      if (exitCode == 1) {
        throw EngineException(process.stderr);
      }
      return exitCode == 0;
    }
  }
}
