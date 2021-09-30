import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base/base_sort_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class SortView extends StatelessWidget {
  const SortView({Key key, @required this.sortOptions}) : super(key: key);

  final sortOptions;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.find<PlatformController>().isMobile
            ? Get.theme.colors().primarySurface
            : Get.theme.colors().surface,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 4,
                width: 40,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Get.theme.colors().onSurface.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2))),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 16, top: 18.5),
              child: Text(tr('sortBy'),
                  style:
                      TextStyleHelper.h6(color: Get.theme.colors().onSurface))),
          sortOptions,
        ],
      ),
    );
  }
}

class SortTile extends StatelessWidget {
  final String sortParameter;
  final BaseSortController sortController;
  const SortTile({Key key, this.sortParameter, @required this.sortController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _selected = sortController.currentSortfilter == sortParameter;
    var title = sortController.getFilterLabel(sortParameter);

    BoxDecoration _selectedDecoration() {
      return BoxDecoration(
          color: Get.theme.colors().bgDescription,
          borderRadius: BorderRadius.circular(6));
    }

    return InkWell(
      onTap: () {
        sortController.changeSort(sortParameter);
        Get.back();
      },
      child: Container(
        height: 40,
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
        padding: const EdgeInsets.only(left: 12, right: 20),
        decoration: _selected ? _selectedDecoration() : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: Text(title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyleHelper.body2()))
                ],
              ),
            ),
            if (_selected)
              AppIcon(
                icon: sortController.isSortAscending.value == true
                    ? SvgIcons.up_arrow
                    : SvgIcons.down_arrow,
                color: Get.theme.colors().primary,
              )
          ],
        ),
      ),
    );
  }
}
