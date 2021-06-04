import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class FiltersHeader extends StatelessWidget {
  const FiltersHeader({
    Key key,
    @required this.filterController,
  }) : super(key: key);

  final BaseFilterController filterController;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SizedBox(
        height: 68,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
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
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 18.5,
                left: 16,
                child: Text('Filter',
                    style: TextStyleHelper.h6(
                        color: Theme.of(context).customColors().onSurface))),
            Positioned(
                top: 5,
                right: 5,
                child: TextButton(
                    onPressed: () async {
                      filterController.resetFilters();
                      Get.back();
                    },
                    child: Text('RESET',
                        style: TextStyleHelper.button(
                            color:
                                Theme.of(context).customColors().systemBlue)))),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 1,
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}
