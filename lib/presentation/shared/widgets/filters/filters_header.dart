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
    return Column(
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
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 16, top: 6),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Filter',
                            style: TextStyleHelper.h6(
                                color:
                                    Theme.of(context).customColors().onSurface))
                      ],
                    ),
                    TextButton(
                        onPressed: () async {
                          filterController.resetFilters();
                          Get.back();
                        },
                        child: Text('RESET',
                            style: TextStyleHelper.button(
                                color: Theme.of(context)
                                    .customColors()
                                    .systemBlue)))
                  ])),
          const Divider(height: 18),
        ]);
  }
}
