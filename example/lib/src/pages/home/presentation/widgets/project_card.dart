import 'package:example/src/global/global.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: context.cardColor,
    );
  }
}
