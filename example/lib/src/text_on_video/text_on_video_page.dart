// ignore_for_file: no_adjacent_strings_in_list

import 'dart:io';

import 'package:example/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moviepy_flutter/moviepy_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;

class TextOnVideoPage extends StatefulHookWidget {
  const TextOnVideoPage({super.key});

  @override
  State<TextOnVideoPage> createState() => _TextOnVideoPageState();
}

class _TextOnVideoPageState extends State<TextOnVideoPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());

    final video = useState<File?>(null);
    final controller = useTextEditingController(text: 'Hello World');
    final alignment = useState(Alignment.center);

    final path = video.value?.path;

    return Scaffold(
      appBar: AppBar(
        title: Text('Text On Video'),
      ),
      body: Form(
        key: formKey.value,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            OutlinedButton(
              onPressed: () => onSelectFile(video),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                path != null ? p.basename(path) : 'Select Video',
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter text',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              controller: controller,
              validator: (v) => v!.isEmpty ? 'required' : null,
            ),
            alignmentDropdown(alignment),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => onExport(
                video.value!,
                formKey.value,
                controller,
                alignment.value,
              ),
              child: Text('Export'),
            )
          ],
        ),
      ),
    );
  }

  Widget alignmentDropdown(ValueNotifier<Alignment> alignment) {
    return ListTile(
      title: Text('Alignment'),
      trailing: DropdownButton(
        value: alignment.value,
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
        onChanged: (value) => alignment.value = value!,
      ),
    );
  }

  Future<void> onExport(
    File media,
    GlobalKey<FormState> formKey,
    TextEditingController controller,
    Alignment alignment,
  ) async {
    if (!formKey.currentState!.validate()) return;

    final dir = await getDirectoryPath();

    final file = File(p.join(dir!, 'text_overlay.webm'));

    final video1Clip = VideoFileClip(
      media,
      trim: Trim(end: Duration(seconds: 5)),
      layers: [
        TextClip(
          'Video 1',
          style: TextClipStyle(fontSize: 40),
        ),
      ],
    );

    final video2Clip = VideoFileClip(
      media,
      trim: Trim(end: Duration(seconds: 5)),
      layers: [TextClip('Video 2', style: TextClipStyle(fontSize: 40))],
    );

    final video = CompositeVideoClip([video1Clip, video2Clip]);
    await video.writeVideoFile(file);

    await OpenFile.open(file.path);
  }

  Future<void> onSelectFile(ValueNotifier<File?> video) async {
    video.value = await pickFile(FileType.video);
  }
}
