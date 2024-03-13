/// movie_creator library
library movie_creator;

import 'package:logger/logger.dart';

export 'animations/animations.dart';
export 'cmd/cmd.dart';
export 'core/core.dart';
export 'generators/generators.dart';
export 'layers/layers.dart';
export 'src/src.dart';

/// use logger for show log
Logger logger = Logger(
  printer: PrettyPrinter(
    printEmojis: false,
    methodCount: 0,
  ),
);
