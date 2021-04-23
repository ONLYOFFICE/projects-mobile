import 'package:flutter/material.dart';

import 'package:projects/presentation/views/authentication/widgets/tfacode_form.dart';

class CodeView extends StatelessWidget {
  CodeView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[const SizedBox(height: 10.0), CodeForm()],
            ),
          ),
        ),
      ),
    );
  }
}
