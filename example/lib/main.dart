import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> onPressed() async {
    await [
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.videos,
    ].request();

    await textClip();

    // final clip = VideoFileClip(file!);
    // await clip.init();

    // print('duration: ${clip.duration}');
    // print('end: ${clip.frameRate}');

    // final img = await clip.nFrames();

    // print(img);

    // await saveFile('Osumffmpeg Frame', img.bytes);
  }

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
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

  Future<void> textClip() async {
    final dir = await getDirectoryPath();

    final file = File(p.join(dir!, 'text_clip.mp4'));

    final textClip = TextClip(
      'Hello World',
      size: Size(720, 720),
    );

    await textClip.writeVideoFile(file);
  }
}
