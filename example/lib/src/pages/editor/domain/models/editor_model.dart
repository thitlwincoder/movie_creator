// import 'dart:convert';

// import 'package:example/src/global/global.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'editor_model.freezed.dart';
// part 'editor_model.g.dart';

// List<EditorModel> editorModelFromJson(String str) {
//   return List<EditorModel>.from(strToMapList(str).map(EditorModel.fromJson));
// }

// String editorModelToJson(List<EditorModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// @unfreezed
// class EditorModel with _$EditorModel {
//   factory EditorModel() = _EditorModel;

//   factory EditorModel.fromJson(Map<String, dynamic> json) =>
//       _$EditorModelFromJson(json);
// }
