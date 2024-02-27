import 'package:example/src/home/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: Text('Movie Flutter Demo'),
      ),
      body: ListView(
        children: const [
          MenuItem(title: 'Text To Video', location: 'text_to_video'),
          MenuItem(title: 'Text On Video', location: 'text_on_video'),
        ],
      ),
    );
  }
}
