import 'package:movie_creator/movie_creator.dart';

class ImageGeneratorImpl implements ImageGenerator {
  ImageGeneratorImpl();

  @override
  Future<String> crop(String input, int width, int height) async {
    final output = await getTempFromPath(input);

    await ffmpeg.execute([
      '-i',
      '"$input"',
      '-vf',
      '"crop=$width:$height:0:0"',
      '"$output"',
      '-y',
    ]);

    return output;
  }

  @override
  Future<String> rotate(String input, int degree) async {
    final output = await getTempFromPath(input);

    await ffmpeg.execute([
      '-i',
      '"$input"',
      '-vf',
      '"rotate=$degree"',
      '"$output"',
      '-y',
    ]);

    return output;
  }

  @override
  Future<String> hflip(String input) async {
    final output = await getTempFromPath(input);

    await ffmpeg.execute([
      '-i',
      '"$input"',
      '-vf',
      '"hflip"',
      '"$output"',
      '-y',
    ]);

    return output;
  }

  @override
  Future<String> vflip(String input) async {
    final output = await getTempFromPath(input);

    await ffmpeg.execute([
      '-i',
      '"$input"',
      '-vf',
      '"vflip"',
      '"$output"',
      '-y',
    ]);

    return output;
  }

  @override
  Future<String> brightness(String input, double value) async {
    final output = await getTempFromPath(input);

    await ffmpeg.execute([
      '-i',
      '"$input"',
      '-vf',
      '"eq=brightness=$value"',
      '"$output"',
      '-y',
    ]);

    return output;
  }

  @override
  Future<String> contrast(String input, double value) async {
    final output = await getTempFromPath(input);

    await ffmpeg.execute([
      '-i',
      '"$input"',
      '-vf',
      '"eq=contrast=$value"',
      '"$output"',
      '-y',
    ]);

    return output;
  }

  @override
  Future<String> saturation(String input, double value) async {
    final output = await getTempFromPath(input);

    await ffmpeg.execute([
      '-i',
      '"$input"',
      '-vf',
      '"eq=saturation=$value"',
      '"$output"',
      '-y',
    ]);

    return output;
  }

  @override
  Future<String> gamma(String input, double value) async {
    final output = await getTempFromPath(input);

    await ffmpeg.execute([
      '-i',
      '"$input"',
      '-vf',
      '"eq=gamma=$value"',
      '"$output"',
      '-y',
    ]);

    return output;
  }

  @override
  Future<bool> save(String input, String output) {
    return ffmpeg.execute([
      '-i',
      '"$input"',
      '"$output"',
      '-y',
    ]);
  }
}
