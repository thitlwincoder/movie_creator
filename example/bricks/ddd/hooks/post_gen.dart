import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  var p = context.logger.progress('dart format');

  var r = await Process.start('dart', ['format', '.']);
  await r.exitCode;

  p.complete('dart format success');
}
