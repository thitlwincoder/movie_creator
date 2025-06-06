import 'package:movie_creator/generators/image_generator/image_generator_impl.dart';

abstract class ImageGenerator {
  factory ImageGenerator() = ImageGeneratorImpl;

  Future<String> crop(String input, int width, int height);

  Future<String> rotate(String input, int degree);

  Future<String> hflip(String input);

  Future<String> vflip(String input);

  Future<String> brightness(String input, double value);

  Future<String> contrast(String input, double value);

  Future<String> saturation(String input, double value);

  Future<String> gamma(String input, double value);

  Future<bool> save(String input, String output);
}
