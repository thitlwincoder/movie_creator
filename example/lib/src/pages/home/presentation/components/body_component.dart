import 'package:example/src/global/extention/extention.dart';
import 'package:example/src/pages/home/presentation/widgets/create_btn.dart';
import 'package:example/src/pages/home/presentation/widgets/project_list.dart';
import 'package:flutter/cupertino.dart';

class BodyComponent extends StatelessWidget {
  const BodyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        CreateBtn(),
        SizedBox(height: 15),
        Text('Projects', style: context.bodyLarge),
        SizedBox(height: 15),
        ProjectList(),
      ],
    );
  }
}
