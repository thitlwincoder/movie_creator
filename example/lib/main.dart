import 'dart:io';

import 'album.dart' as album;
import 'image.dart' as image;
import 'player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Creator Examples')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Album'),
            trailing: const Icon(CupertinoIcons.right_chevron),
            onTap: () => onTap(album.main()),
          ),
          ListTile(
            title: const Text('Image'),
            trailing: const Icon(CupertinoIcons.right_chevron),
            onTap: () => onTap(image.main()),
          ),
        ],
      ),
    );
  }

  Future<void> onTap(Future<File> main) async {
    var file = await main;

    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Player(file)),
    );
  }
}
