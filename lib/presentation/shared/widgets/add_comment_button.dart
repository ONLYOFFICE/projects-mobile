import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class AddCommentButton extends StatelessWidget {
  final Function() onPressed;
  const AddCommentButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Theme.of(context).customColors().onSurface.withOpacity(0.1),
            offset: const Offset(0, 0.85),
          ),
        ],
        color: Theme.of(context).customColors().backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 32,
        // ignore: deprecated_member_use
        child: FlatButton(
          minWidth: double.infinity,
          padding: const EdgeInsets.only(left: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side:
                  BorderSide(color: Theme.of(context).customColors().outline)),
          color: Theme.of(context).customColors().bgDescription,
          onPressed: onPressed,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Add comment...',
                style: TextStyleHelper.body2(
                    color: Theme.of(context)
                        .customColors()
                        .onBackground
                        .withOpacity(0.4))),
          ),
        ),
      ),
    );
  }
}
