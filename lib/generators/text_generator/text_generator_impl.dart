import 'package:movie_creator/filters/filter.dart';
import 'package:movie_creator/generators/text_generator/text_generator.dart';
import 'package:movie_creator/movie_creator.dart';

class TextGeneratorImpl implements TextGenerator {
  @override
  Future<String> glow(String input, DrawText drawText) async {
    final output = await getTempFromPath(input);

    final d = filterList([
      drawText,
      drawText
        ..start = 1
        ..end = 2
        ..alpha = 'if(lt(t,1),0,(t-1))',
      drawText
        ..start = 2
        ..end = 3
        ..alpha = 'if(lt(t,2),0,(3-t))',
    ]);

    await ffmpeg.execute([
      '-i',
      '"$input"',
      '-vf',
      d,
      '"$output"',
      '-y',
    ]);

    return output;
  }
}
