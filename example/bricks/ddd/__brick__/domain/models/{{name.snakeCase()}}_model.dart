import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:example/src/global/global.dart';

part '{{name.snakeCase()}}_model.freezed.dart';
part '{{name.snakeCase()}}_model.g.dart';

List<{{name.pascalCase()}}Model> {{name.camelCase()}}ModelFromJson(String str) {
  return List<{{name.pascalCase()}}Model>.from(strToMapList(str).map({{name.pascalCase()}}Model.fromJson));
}

String {{name.camelCase()}}ModelToJson(List<{{name.pascalCase()}}Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@unfreezed
class {{name.pascalCase()}}Model with _${{name.pascalCase()}}Model {
  factory {{name.pascalCase()}}Model() = _{{name.pascalCase()}}Model;

  factory {{name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      _${{name.pascalCase()}}ModelFromJson(json);
}
