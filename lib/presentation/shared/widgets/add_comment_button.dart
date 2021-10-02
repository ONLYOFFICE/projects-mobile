import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            color: Get.theme.colors().onSurface.withOpacity(0.1),
            offset: const Offset(0, 0.85),
          ),
        ],
        color: Get.theme.colors().backgroundColor,
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
              side: BorderSide(color: Get.theme.colors().outline)),
          color: Get.theme.colors().bgDescription,
          onPressed: onPressed,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(tr('addComment'),
                style: TextStyleHelper.body2(
                    color: Get.theme.colors().onBackground.withOpacity(0.4))),
          ),
        ),
      ),
    );
  }
}
