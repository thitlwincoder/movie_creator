import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/services/app_preference/models/app_preference.dart';

part 'isar_provider.g.dart';

@riverpod
class IsarService extends _$IsarService {
  @override
  Future<Isar?> build() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [AppPreferencesSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> closeIsar() async {
    final isar = state.value;
    await isar?.close();
  }

  Future<void> cleanIsarDB() async {
    final isar = state.value;
    await isar?.writeTxn(() => isar.clear());
  }
}
