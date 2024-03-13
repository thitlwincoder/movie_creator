import '../services/{{name.snakeCase()}}_service.dart';
import '../../domain/models/{{name.snakeCase()}}_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{{name.snakeCase()}}_provider.g.dart';

@Riverpod(keepAlive: true)
List<{{name.pascalCase()}}Model> {{name.camelCase()}}({{name.pascalCase()}}Ref ref) {
  final service = ref.watch({{name.camelCase()}}ServiceProvider);
  return service.whenData((value) => value).value ?? [];
}
