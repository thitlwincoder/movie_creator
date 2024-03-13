import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/editor_service.dart';

part 'editor_provider.g.dart';

@Riverpod(keepAlive: true)
List editor(EditorRef ref) {
  final service = ref.watch(editorServiceProvider);
  return service.whenData((value) => value).value ?? [];
}
