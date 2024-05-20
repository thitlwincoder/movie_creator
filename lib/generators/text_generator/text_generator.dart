import 'package:movie_creator/generators/text_generator/text_generator_impl.dart';
import 'package:movie_creator/movie_creator.dart';

abstract class TextGenerator {
  static TextGenerator get instance => TextGeneratorImpl();

  Future<String> glow(String input, DrawText drawText);
}
