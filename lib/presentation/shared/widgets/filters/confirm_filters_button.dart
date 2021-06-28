import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class ConfirmFiltersButton extends StatelessWidget {
  const ConfirmFiltersButton({
    Key key,
    @required this.filterController,
  }) : super(key: key);

  final BaseFilterController filterController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: TextButton(
          onPressed: () async {
            filterController.applyFilters();
            Get.back();
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                  (_) => EdgeInsets.only(
                      left: Get.width * 0.243,
                      right: Get.width * 0.243,
                      top: 10,
                      bottom: 12)),
              backgroundColor: MaterialStateProperty.resolveWith<Color>((_) {
                return Theme.of(context).customColors().primary;
              }),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)))),
          child: Text(
              tr('filterConfirmButton', args: [
                filterController.suitableResultCount.value.toString(),
                filterController.filtersTitle
              ]),
              style: TextStyleHelper.button(
                  color: Theme.of(context).customColors().onPrimary)),
        ),
      ),
    );
  }
}
