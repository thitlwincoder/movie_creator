import 'package:example/services/dio/dio_helper_provider.dart';
import '../models/{{name.snakeCase()}}_model.dart';
import '../../infrastructure/repositories/{{name.snakeCase()}}_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{{name.snakeCase()}}_repository.g.dart';

@Riverpod(keepAlive: true)
{{name.pascalCase()}}Repository {{name.camelCase()}}Repository({{name.pascalCase()}}RepositoryRef ref) {
  return {{name.pascalCase()}}RepositoryImpl(ref.watch(dioHelperProvider));
}

abstract class {{name.pascalCase()}}Repository {
  Future<List<{{name.pascalCase()}}Model>> get();
}
