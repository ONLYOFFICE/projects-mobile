import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class ProjectSort extends StatelessWidget {
  const ProjectSort({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: BorderRadius.only(
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
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2))),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 16, top: 18.5),
              child: Text('Sort by',
                  style: TextStyleHelper.h6(
                      color: Theme.of(context).customColors().onSurface))),
          const SizedBox(height: 14.5),
          const Divider(height: 9, thickness: 1),
          const SortTile(title: 'Creation date'),
          const SortTile(title: 'Title'),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}

class SortTile extends StatelessWidget {
  final String title;
  final Function onTap;

  const SortTile({Key key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _sortController = Get.find<ProjectsSortController>();

    var _selected = _sortController.currentSortText.value == title;
    BoxDecoration _selectedDecoration() {
      return BoxDecoration(
          color: Theme.of(context).customColors().bgDescription,
          borderRadius: BorderRadius.circular(6));
    }

    return InkWell(
      onTap: onTap ??
          () {
            _sortController.changeSort(title);

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
                  icon:
                      _sortController.currentSortOrderText.value == 'ascending'
                          ? SvgIcons.up_arrow
                          : SvgIcons.down_arrow)
          ],
        ),
      ),
    );
  }
}
