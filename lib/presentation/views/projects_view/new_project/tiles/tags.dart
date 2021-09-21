import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class TagsTile extends StatelessWidget {
  const TagsTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool _isNotEmpty = controller.tags.isNotEmpty;

        return NewItemTile(
          caption: _isNotEmpty ? '${tr('tags')}:' : null,
          text: _isNotEmpty ? controller.tagsText.value : tr('addTag'),
          icon: SvgIcons.tag,
          iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
          selectedIconColor: Get.theme.colors().onBackground,
          isSelected: _isNotEmpty,
          suffix: _isNotEmpty
              ? InkWell(
                  onTap: controller.showTags,
                  child: Icon(
                    Icons.navigate_next,
                    size: 24,
                    color: Get.theme.colors().onBackground,
                  ),
                )
              : null,
          onTap: controller.showTags,
        );
      },
    );
  }
}
