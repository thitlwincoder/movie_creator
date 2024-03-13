import 'package:example/src/global/global.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends AppBar {
  AppBarComponent(BuildContext context, {super.key})
      : super(
          title: Text(
            'Movie Creator',
            style: context.bodyLarge,
          ),
        );
}
