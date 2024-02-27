import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({required this.title, required this.location, super.key});

  final String title;
  final String location;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).iconTheme.color;

    return ListTile(
      onTap: () => context.go('/$location'),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: Icon(Icons.arrow_right_sharp, color: color),
    );
  }
}
