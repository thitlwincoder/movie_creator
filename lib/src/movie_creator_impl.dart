import 'dart:io';

import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit_config.dart';
import 'package:movie_creator/movie_creator.dart';
import 'package:movie_creator/utils/temp.dart';
import 'package:path_provider/path_provider.dart';

class MovieCreatorImpl implements MovieCreator {
  MovieCreatorImpl({
    required this.height,
    required this.width,
    this.fps,
    this.audio,
    Map<String, FontFile>? fonts,
  }) : fonts = fonts ?? {};

  final int? fps;
  final int width;
  final int height;
  final String? audio;
  final Map<String, FontFile> fonts;

  List<MovieScene> scenes = [];

  @override
  void addFont({required FontFile fontFile, required String fontFamily}) {
    fonts[fontFamily] = fontFile;
  }

  @override
  void addScene(MovieScene scene) {
    scenes.add(scene);
  }

  @override
  Future<void> clearTemps() async {
    final dir = await getTemporaryDirectory();
    await dir.delete(recursive: true);
  }

  @override
  Future<File> export({String extension = 'mp4'}) async {
    await _setFonts();
    await clearTemps();

    final ext = '.$extension';

    final temps = <String>[];
    final sceneOutputs = <String>[];

    await Future.forEach(scenes, (scene) async {
      temps.clear();

      var isSuccess = true;

      var temp = await getTemp(ext);
      isSuccess = await scene.exportBgVideo(width, height, fps, temp);
      if (!isSuccess) return;

      temps.add(temp);
      scene.temp = temp;

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
            isSuccess = await layer.export(
              temps.last,
              fps,
              temp,
              height,
              width,
            );
          }

          if (layer is AlbumLayer) {
            isSuccess = await layer.export(temps.last, fps, temp);
          }

          if (layer is VideoLayer) {
            isSuccess = await layer.export(temps.last, fps, temp);
          }

          if (layer is GifLayer) {
            isSuccess = await layer.export(temps.last, fps, temp);
          }

          temps.add(temp);
        });
      }

      if (!isSuccess) return;

      if (textLayers.isNotEmpty) {
        final temp = await getTemp(ext);
        isSuccess = await textLayerExporter(
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

    final output = await getTemp(ext);

    await _combileSceneTempToOutput(scenes, output);

    return File(output);
  }

  Future<bool> _combileSceneTempToOutput(
    List<MovieScene> scenes,
    String output,
  ) async {
    final prefix = StringBuffer();
    final input = <String>[];

    for (var i = 0; i < scenes.length; i++) {
      final scene = scenes[i];
      final temp = scene.temp;

      if (temp != null) {
        input.addAll(['-i', temp]);
      }

      prefix.write('[$i:v:0]');
    }

    final cmd = <String>[
      ...input,
      if (audio != null) ...['-i', audio!],
      '-filter_complex',
      '"${prefix}concat=n=${scenes.length}:v=1:a=0[v]"',
      '-map',
      '"[v]"',
      if (audio != null) ...[
        '-c:v',
        'copy',
        '-c:a',
        'aac',
        '-strict',
        'experimental',
      ],
      output,
      '-y',
    ];

    return ffmpeg.execute(cmd);
  }

  Future<void> _setFonts() async {
    final paths = [
      '/system/fonts',
      '/System/Library/Fonts',
    ];

    if (fonts.isNotEmpty) {
      await Future.forEach(fonts.values, (e) async {
        var path = e.path;

        if (e.type == FileType.asset) {
          path = await moveAssetToTemp(path);
        }

        paths.add(path);
      });
    }

    await FFmpegKitConfig.setFontDirectoryList(paths);
  }
}
