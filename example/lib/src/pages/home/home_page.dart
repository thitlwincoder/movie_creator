import 'package:example/src/pages/home/presentation/components/appbar_component.dart';
import 'package:example/src/pages/home/presentation/components/body_component.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(context),
      body: BodyComponent(),
    );
  }
}
