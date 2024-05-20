import 'package:movie_creator/filters/filter.dart';

class Rotate extends Filter {
  Rotate(this.degree);

  final int degree;

  @override
  String toString() {
    return 'rotate=$degree*PI/180';
  }
}
