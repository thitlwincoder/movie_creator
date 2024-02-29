// import 'dart:io';

// import 'package:example/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:movie_flutter/movie_flutter.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path/path.dart' as p;

// class TextToVideoPage extends StatefulHookWidget {
//   const TextToVideoPage({super.key});

//   @override
//   State<TextToVideoPage> createState() => _TextClipPageState();
// }

// class _TextClipPageState extends State<TextToVideoPage> {
//   @override
//   Widget build(BuildContext context) {
//     final formKey = useState(GlobalKey<FormState>());
//     final controller = useTextEditingController(text: 'Hello World');
//     final alignment = useState(Alignment.center);

//     return Scaffold(
//       appBar: AppBar(title: Text('Text To Video')),
//       body: Form(
//         key: formKey.value,
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         child: ListView(
//           padding: EdgeInsets.all(20),
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Enter text',
//                 contentPadding: EdgeInsets.symmetric(horizontal: 10),
//               ),
//               controller: controller,
//               validator: (v) => v!.isEmpty ? 'required' : null,
//             ),
//             alignmentDropdown(alignment),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 onExport(formKey.value, controller, alignment.value);
//               },
//               child: Text('Export'),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget alignmentDropdown(ValueNotifier<Alignment> alignment) {
//     return ListTile(
//       title: Text('Alignment'),
//       trailing: DropdownButton(
//         value: alignment.value,
//         items: const [
//           DropdownMenuItem(
//             value: Alignment.center,
//             child: Text('Center'),
//           ),
//           DropdownMenuItem(
//             value: Alignment.topLeft,
//             child: Text('Top Left'),
//           ),
//           DropdownMenuItem(
//             value: Alignment.topCenter,
//             child: Text('Top Center'),
//           ),
//           DropdownMenuItem(
//             value: Alignment.topRight,
//             child: Text('Top Right'),
//           ),
//           DropdownMenuItem(
//             value: Alignment.bottomLeft,
//             child: Text('Bottom Left'),
//           ),
//           DropdownMenuItem(
//             value: Alignment.bottomCenter,
//             child: Text('Bottom Center'),
//           ),
//           DropdownMenuItem(
//             value: Alignment.bottomRight,
//             child: Text('Bottom Right'),
//           ),
//         ],
//         onChanged: (value) => alignment.value = value!,
//       ),
//     );
//   }

//   Future<void> onExport(
//     GlobalKey<FormState> formKey,
//     TextEditingController controller,
//     Alignment alignment,
//   ) async {
//     if (!formKey.currentState!.validate()) return;

//     final dir = await getDirectoryPath();

//     final file = File(p.join(dir!, 'text_clip_2.mp4'));

//     final textClip = TextClip(
//       controller.text.trim(),
//       padding: EdgeInsets.all(20),
//       duration: Duration(seconds: 10),
//       style: TextClipStyle(fontSize: 30, alignment: alignment),
//     );

//     await textClip.writeVideoFile(file);

//     await OpenFile.open(file.path);
//   }
// }
