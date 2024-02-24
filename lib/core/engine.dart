import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/services.dart';
import 'package:moviepy_flutter/core/core.dart';

class _Engine {
  _Engine(this._execs);

  final Execs _execs;

  Future<Stream<List<int>>> executeStream(List<String> commands) async {
    if (Platform.isAndroid || Platform.isIOS) {
      switch (_execs) {
        case Execs.ffmpeg:
          final session = await FFmpegKit.execute(commands.join(' '));
          return session
              .getOutput()
              .asStream()
              .map((event) => utf8.encode(event!))
              .asBroadcastStream();

        case Execs.ffprobe:
          final session = await FFprobeKit.execute(commands.join(' '));
          return session
              .getOutput()
              .asStream()
              .map((event) => utf8.encode(event!))
              .asBroadcastStream();
        case Execs.ffplay:
          throw MissingPluginException('FFplay not available.');
      }
    } else {
      final process = await Process.start(
        _execs.name,
        commands,
        runInShell: true,
      );

      return StreamGroup.merge([
        process.stderr,
        process.stdout,
      ]).asBroadcastStream();
    }
  }

  Future<String> execute(List<String> commands) async {
    if (Platform.isAndroid || Platform.isIOS) {
      switch (_execs) {
        case Execs.ffmpeg:
          final session = await FFmpegKit.execute(commands.join(' '));
          return (await session.getOutput())!;
        case Execs.ffprobe:
          final session = await FFprobeKit.execute(commands.join(' '));
          return (await session.getOutput())!;
        case Execs.ffplay:
          throw MissingPluginException('FFplay not available.');
      }
    } else {
      final process = await Process.run(_execs.name, commands);

      if (process.exitCode == 1) {
        throw EngineException(process.stderr);
      }
      return '${process.stdout}';
    }
  }

  Future<String> executeAsync(List<String> commands) async {
    if (Platform.isAndroid || Platform.isIOS) {
      switch (_execs) {
        case Execs.ffmpeg:
          final session = await FFmpegKit.executeAsync(commands.join(' '));
          return (await session.getOutput())!;
        case Execs.ffprobe:
          final session = await FFprobeKit.executeAsync(commands.join(' '));
          return (await session.getOutput())!;
        case Execs.ffplay:
          throw MissingPluginException('FFplay not available.');
      }
    } else {
      final process = await Process.run(_execs.name, commands);

      if (process.exitCode == 1) {
        throw EngineException(process.stderr);
      }
      return '${process.stdout}';
    }
  }
}

_Engine ffmpeg = _Engine(Execs.ffmpeg);
_Engine ffprobe = _Engine(Execs.ffprobe);
_Engine ffplay = _Engine(Execs.ffplay);
