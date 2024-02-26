import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';
import 'package:open_file/open_file.dart';
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
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();
  Alignment alignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    [
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.videos,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: controller,
          ),
          ListTile(
            title: Text('Alignment'),
            trailing: DropdownButton(
              value: alignment,
              items: const [
                DropdownMenuItem(
                  value: Alignment.center,
                  child: Text('Center'),
                ),
                DropdownMenuItem(
                  value: Alignment.topLeft,
                  child: Text('Top Left'),
                ),
                DropdownMenuItem(
                  value: Alignment.topCenter,
                  child: Text('Top Center'),
                ),
                DropdownMenuItem(
                  value: Alignment.topRight,
                  child: Text('Top Right'),
                ),
                DropdownMenuItem(
                  value: Alignment.bottomLeft,
                  child: Text('Bottom Left'),
                ),
                DropdownMenuItem(
                  value: Alignment.bottomCenter,
                  child: Text('Bottom Center'),
                ),
                DropdownMenuItem(
                  value: Alignment.bottomRight,
                  child: Text('Bottom Right'),
                ),
              ],
              onChanged: (value) {
                alignment = value!;
                setState(() {});
              },
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: textClip,
            child: Text('Export'),
          )
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: onPressed,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  Future<void> onPressed() async {
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

    TextStyle();

    final textClip = TextClip(
      controller.text.trim(),
      color: Colors.green,
      padding: EdgeInsets.all(20),
      duration: Duration(seconds: 10),
      style: TextClipStyle(
        fontSize: 50,
        align: alignment,
        // backgroundColor: Colors.red,
      ),
    );

    await textClip.writeVideoFile(file);

    await OpenFile.open(file.path);
  }
}
