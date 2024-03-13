import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructure/repositories/home_repository_impl.dart';

part 'home_repository.g.dart';

@Riverpod(keepAlive: true)
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepositoryImpl();
}

abstract class HomeRepository {
  Future<List> get();
}
