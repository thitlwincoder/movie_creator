import 'package:example/services/dio/dio_helper_provider.dart';
import '../../domain/models/{{name.snakeCase()}}_model.dart';
import '../../domain/repositories/{{name.snakeCase()}}_repository.dart';

 class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository {
   {{name.pascalCase()}}RepositoryImpl(this.dio);

  final DioHelper dio;

  @override
  Future<List<{{name.pascalCase()}}Model>> get()async{
final r = await dio.get('/posts');
    return {{name.camelCase()}}ModelFromJson(r.data);
  }
}
