import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class StatusTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final bool selected;

  const StatusTile({Key key, this.icon, this.title, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration _selectedDecoration() {
      return BoxDecoration(
          color: Get.theme.colors().bgDescription,
          borderRadius: BorderRadius.circular(6));
    }

    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      decoration: selected ? _selectedDecoration() : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 48, child: icon),
                Flexible(
                    child: Text(title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyleHelper.body2())),
              ],
            ),
          ),
          if (selected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.done_rounded,
                color: Get.theme.colors().primary,
              ),
            )
        ],
      ),
    );
  }
}
