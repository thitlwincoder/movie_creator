import 'package:movie_creator/core/engine_impl.dart';

enum Execs { ffplay, ffmpeg, ffprobe }

abstract class Engine {
  factory Engine(Execs execs) = EngineImpl;

  Future<bool> execute(List<String> commands);
}

Engine ffmpeg = Engine(Execs.ffmpeg);
Engine ffprobe = Engine(Execs.ffprobe);
Engine ffplay = Engine(Execs.ffplay);
