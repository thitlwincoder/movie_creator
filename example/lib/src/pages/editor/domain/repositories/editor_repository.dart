import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructure/repositories/editor_repository_impl.dart';

part 'editor_repository.g.dart';

@Riverpod(keepAlive: true)
EditorRepository editorRepository(EditorRepositoryRef ref) {
  return EditorRepositoryImpl();
}

abstract class EditorRepository {
  Future<List> get();
}
