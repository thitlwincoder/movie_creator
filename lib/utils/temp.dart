import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String> getTemp(String ext, {String? name, String? dir}) async {
  final _dir = dir ?? (await getTemporaryDirectory()).path;

  final date = DateTime.now().millisecond;

  final filename = '${name ?? date}$ext';

  final temp = p.join(_dir, filename);

  await File(temp).create();
  return temp;
}

Future<String> getTempFromPath(String path, {String? name}) async {
  return getTemp(p.extension(path), name: name);
}

Future<String> moveAssetToTemp(String path, {String? name}) async {
  final bytes = await rootBundle.load(path);

  final tmp = await getTempFromPath(path, name: name);
  await File(tmp).writeAsBytes(bytes.buffer.asUint8List());

  return tmp;
}
