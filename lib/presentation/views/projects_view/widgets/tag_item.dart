import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/tag_itemDTO.dart';

import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class TagItem extends StatelessWidget {
  final TagItemDTO tagItemDTO;
  final Function onTapFunction;

  const TagItem({
    Key key,
    @required this.onTapFunction,
    @required this.tagItemDTO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction,
      child: Container(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                tagItemDTO.tag.title.replaceAll(' ', '\u00A0'),
                overflow: TextOverflow.ellipsis,
                style: TextStyleHelper.subtitle1(),
              ),
            ),
            Obx(() {
              if (tagItemDTO.isSelected.isTrue) {
                return SizedBox(
                    width: 72,
                    child: Icon(Icons.check_box,
                        color: Theme.of(context).customColors().primary));
              } else {
                return const SizedBox(
                  width: 72,
                  child: Icon(Icons.check_box_outline_blank_outlined),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
