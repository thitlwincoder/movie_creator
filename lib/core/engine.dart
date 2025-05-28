import 'dart:io';

import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit_flutter_minimal.dart';
import 'package:flutter/services.dart';
import 'package:movie_creator/movie_creator.dart';

enum Execs { ffplay, ffmpeg, ffprobe }

class _Engine {
  _Engine(this._execs);

  final Execs _execs;

  Future<bool> execute(List<String> commands) async {
    if (Platform.isAndroid || Platform.isIOS) {
      switch (_execs) {
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
      final process = await Process.run(_execs.name, commands);

      final exitCode = process.exitCode;

      if (exitCode == 1) {
        throw EngineException(process.stderr);
      }
      return exitCode == 0;
    }
  }
}

_Engine ffmpeg = _Engine(Execs.ffmpeg);
_Engine ffprobe = _Engine(Execs.ffprobe);
_Engine ffplay = _Engine(Execs.ffplay);
