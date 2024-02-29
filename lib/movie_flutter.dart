/// A Very Good Project created by Very Good CLI.
library movie_flutter;

import 'package:logger/logger.dart';

export 'core/core.dart';
export 'src/src.dart';
export 'video/video.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    printEmojis: false,
    methodCount: 0,
  ),
);
