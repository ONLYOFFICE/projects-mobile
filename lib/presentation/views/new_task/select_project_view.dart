import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class SelectProjectView extends StatelessWidget {
  const SelectProjectView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyledAppBar(
        titleText: 'Select project',
        actions: [
          IconButton(
              icon: Icon(Icons.check_rounded), onPressed: () => print('da'))
        ],
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(),
            )),
          );
        },
      ),
    );
  }
}
