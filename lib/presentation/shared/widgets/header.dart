import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

// TODO: CAN DELETE THIS FILE
class CustomHeaderWithButton extends StatelessWidget {
  const CustomHeaderWithButton({
    Key key,
    @required this.function,
    @required this.title,
  }) : super(key: key);

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

class CustomHeaderWithoutButton extends StatelessWidget {
  const CustomHeaderWithoutButton({
    Key key,
    @required this.title,
  }) : super(key: key);

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
            ],
          ),
        ),
      ),
    );
  }
}
