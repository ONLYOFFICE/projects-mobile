import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class FilterElement extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Color titleColor;
  final bool cancelButtonEnabled;
  final Function() onTap;
  final Function() onCancelTap;

  const FilterElement(
      {Key key,
      this.isSelected = false,
      this.title,
      this.titleColor,
      this.onTap,
      this.cancelButtonEnabled = false,
      this.onCancelTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.only(top: 5, bottom: 6, left: 12, right: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Get.theme.colors().outline, width: 0.5),
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? Get.theme.colors().primary
              : Get.theme.colors().bgDescription,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.body2(
                      color: isSelected
                          ? Get.theme.colors().onPrimarySurface
                          : titleColor ?? Get.theme.colors().primary)),
            ),
            if (cancelButtonEnabled)
              Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: InkWell(
                      onTap: onCancelTap,
                      child: const Icon(Icons.cancel,
                          color: Colors.white, size: 18))),
          ],
        ),
      ),
    );
  }
}
