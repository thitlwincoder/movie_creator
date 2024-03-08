import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:flutter/services.dart';
import 'package:movie_flutter/movie_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class VideoCreator {
  VideoCreator({
    required this.height,
    required this.width,
    this.fps = 24,
    this.debug = false,
  });

  final int height;
  final int width;
  final int fps;
  final bool debug;

  List<MovieScene> scenes = [];

  void addScene(MovieScene scene) {
    scenes.add(scene);
  }

  Future<void> export(String outputPath) async {
    await FFmpegKitConfig.setFontDirectory('/system/fonts/');

    final ext = p.extension(outputPath);

    final temps = <String>[];
    final sceneOutputs = <String>[];

    await Future.forEach(scenes, (scene) async {
      temps.clear();

      var isSuccess = true;

      var temp = await getTemp(ext);
      isSuccess = await scene.exportBgVideo(width, height, fps, temp);
      if (!isSuccess) return;

      temps.add(temp);

      final textLayers = <TextLayer>[];

      final layers = scene.layers;

      if (layers.isNotEmpty) {
        await Future.forEach(layers, (layer) async {
          if (!isSuccess) return;

          if (layer is TextLayer) {
            textLayers.add(layer);
            return;
          }

          temp = await getTemp(ext);

          if (layer is ImageLayer) {
            isSuccess = await layer.export(temps.last, temp);
          }

          if (layer is AlbumLayer) {
            isSuccess = await layer.export(temps.last, temp);
          }

          if (layer is VideoLayer) {
            isSuccess = await layer.export(temps.last, temp);
          }

          temps.add(temp);
        });

        if (!isSuccess) return;

        if (textLayers.isNotEmpty) {
          final temp = await getTemp(ext);
          isSuccess = await TextLayer.export(textLayers, temps.last, temp);
          if (!isSuccess) return;
          sceneOutputs.add(temp);
        }
      }
    });

    await _copySceneTempToOutput(sceneOutputs, outputPath);

    await clearTemps(temps, sceneOutputs);
  }

  Future<bool> _copySceneTempToOutput(
    List<String> scense,
    String output,
  ) {
    return ffmpeg.execute([
      for (final e in scense) ...['-i', e],
      '-c:a',
      'copy',
      output,
      '-y'
    ]);
  }

  Future<void> clearTemps(List<String> temps, List<String> sceneOutputs) async {
    final dir = await getTemporaryDirectory();

    temps.addAll(sceneOutputs);

    await Future.forEach(temps, (temp) async {
      final path = p.join(dir.path, temp);
      await File(path).delete();
    });
  }
}

Future<String> getTemp(String ext, {String? name}) async {
  final dir = await getTemporaryDirectory();

  final filename = '${name ?? DateTime.now().toIso8601String()}$ext';

  final temp = p.join(dir.path, filename);

  await File(temp).create();
  return temp;
}

Future<String> moveAssetToTemp(String path, {String? name}) async {
  final bytes = await rootBundle.load(path);

  final tmp = await getTemp(p.extension(path), name: name);
  await File(tmp).writeAsBytes(bytes.buffer.asUint8List());

  return tmp;
}
