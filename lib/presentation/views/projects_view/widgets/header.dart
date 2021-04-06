import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({
    Key key,
    // @required this.controller,
    @required this.function,
    @required this.title,
  }) : super(key: key);

  // final NewProjectController controller;
  final Function() function;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        child: Material(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: TextStyleHelper.headline6(
                      color: Theme.of(context).customColors().onSurface),
                ),
              ),
              InkWell(
                onTap: () {
                  function();
                },
                child: Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
