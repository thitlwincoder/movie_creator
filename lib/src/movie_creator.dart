import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:flutter/services.dart';
import 'package:movie_creator/movie_creator.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MovieCreator {
  MovieCreator({
    required this.height,
    required this.width,
    this.fps,
    this.fonts = const {},
  });

  final int height;
  final int width;
  final int? fps;
  final Map<String, FontFile> fonts;

  List<MovieScene> scenes = [];

  void addScene(MovieScene scene) {
    scenes.add(scene);
  }

  void addFont({
    required FontFile fontFile,
    required String fontFamily,
  }) {
    fonts[fontFamily] = fontFile;
  }

  Future<void> export(String outputPath) async {
    await _setFonts();

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
            isSuccess = await layer.export(temps.last, fps, temp);
          }

          if (layer is AlbumLayer) {
            isSuccess = await layer.export(temps.last, fps, temp);
          }

          if (layer is VideoLayer) {
            isSuccess = await layer.export(temps.last, fps, temp);
          }

          temps.add(temp);
        });
      }

      if (!isSuccess) return;

      if (textLayers.isNotEmpty) {
        final temp = await getTemp(ext);
        isSuccess = await TextLayer.export(
          textLayers,
          fps,
          temps.last,
          temp,
          fonts,
        );
        if (!isSuccess) return;
        sceneOutputs.add(temp);
        scene.temp = temp;
      } else {
        scene.temp = temps.last;

        sceneOutputs.add(temps.last);
      }
    });

    await _combileSceneTempToOutput(scenes, outputPath);

    await clearTemps(temps, sceneOutputs);
  }

  Future<bool> _combileSceneTempToOutput(
    List<MovieScene> scenes,
    String output,
  ) async {
    final prefix = StringBuffer();
    final input = <String>[];

    final buffer = StringBuffer();

    for (var i = 0; i < scenes.length; i++) {
      final scene = scenes[i];

      input.addAll(['-i', scene.temp!]);
      prefix.write('[$i:v:0]');
    }

    final temp = await getTemp('.txt');
    await File(temp).writeAsString(buffer.toString());

    return ffmpeg.execute([
      ...input,
      '-filter_complex',
      '"${prefix}concat=n=${scenes.length}:v=1:a=0[v]"',
      '-map',
      '"[v]"',
      output,
      '-y',
    ]);
  }

  Future<void> clearTemps(List<String> temps, List<String> sceneOutputs) async {
    final dir = await getTemporaryDirectory();

    temps.addAll(sceneOutputs);

    await Future.forEach(temps, (temp) async {
      final path = p.join(dir.path, temp);
      final file = p.basename(path);

      await File(p.join(dir.path, file)).delete(recursive: true);
    });
  }

  Future<void> _setFonts() async {
    if (fonts.isEmpty) {
      final paths = <String>[];

      await Future.forEach(fonts.values, (e) async {
        var path = e.path;

        if (e.type == FileType.asset) {
          path = await moveAssetToTemp(e.path);
        }

        paths.add(path);
      });

      paths.add('/system/fonts/');

      await FFmpegKitConfig.setFontDirectoryList(paths);
    } else {
      await FFmpegKitConfig.setFontDirectory('/system/fonts/');
    }
  }
}

Future<String> getTemp(String ext, {String? name}) async {
  final dir = await getTemporaryDirectory();

  final dateformat = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '-')
      .replaceAll(':', '-');

  final filename = '${name ?? dateformat}$ext';

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
