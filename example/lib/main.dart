import 'dart:io';
import 'dart:typed_data';

import 'package:example/src/home/home_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routerConfig: router,
    );
  }
}

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => HomePage(),
      // routes: [
      //   GoRoute(
      //     path: 'text_to_video',
      //     builder: (_, __) => TextToVideoPage(),
      //   ),
      //   GoRoute(
      //     path: 'text_on_video',
      //     builder: (_, __) => TextOnVideoPage(),
      //   ),
      // ],
    ),
  ],
);

Future<File?> pickFile(FileType type) async {
  final result = await FilePicker.platform.pickFiles(type: type);
  if (result == null) return null;
  return File(result.files.single.path!);
}

Future<String?> getDirectoryPath() {
  return FilePicker.platform.getDirectoryPath();
}

Future<String?> saveFile(String name, Uint8List bytes) {
  return FileSaver.instance.saveFile(
    name: name,
    ext: 'jpg',
    bytes: bytes,
    mimeType: MimeType.jpeg,
  );
}
