import 'package:movie_creator/layers/album_layer_impl.dart';
import 'package:movie_creator/movie_creator.dart';

abstract class AlbumLayer extends Layer {
  factory AlbumLayer.asset({
    required List<String> paths,
    int? x,
    int? y,
    int? width,
    int? height,
    double? duration,
  }) = AlbumLayerImpl.asset;

  factory AlbumLayer.file({
    required List<String> paths,
    int? x,
    int? y,
    int? width,
    int? height,
    double? duration,
  }) = AlbumLayerImpl.file;

  Future<bool> export(String input, int? fps, String output);
}
