import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/home_service.dart';

part 'home_provider.g.dart';

@Riverpod(keepAlive: true)
List home(HomeRef ref) {
  final service = ref.watch(homeServiceProvider);
  return service.whenData((value) => value).value ?? [];
}
