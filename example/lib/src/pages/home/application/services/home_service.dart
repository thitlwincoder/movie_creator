import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/home_repository.dart';

part 'home_service.g.dart';

@Riverpod(keepAlive: true)
class HomeService extends _$HomeService {
  late HomeRepository _repo;

  @override
  Future<List> build() {
    _repo = ref.watch(homeRepositoryProvider);
    return _repo.get();
  }
}
