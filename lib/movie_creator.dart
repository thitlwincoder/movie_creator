/// A Very Good Project created by Very Good CLI.
library movie_creator;

import 'package:logger/logger.dart';

export 'cmd/cmd.dart';
export 'core/core.dart';
export 'layers/layers.dart';
export 'src/src.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    printEmojis: false,
    methodCount: 0,
  ),
);
