import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/{{name.snakeCase()}}_repository.dart';
import '../../domain/models/{{name.snakeCase()}}_model.dart';
part '{{name.snakeCase()}}_service.g.dart';

@Riverpod(keepAlive: true)
class {{name.pascalCase()}}Service extends _${{name.pascalCase()}}Service {
  late {{name.pascalCase()}}Repository _repo;

  @override
  Future<List<{{name.pascalCase()}}Model>> build() {
    _repo = ref.watch({{name.camelCase()}}RepositoryProvider);
    return _repo.get();
  }
}
