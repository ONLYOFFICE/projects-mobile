import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class FiltersButton extends StatelessWidget {
  const FiltersButton({
    Key key,
    this.controler,
  }) : super(key: key);
  final controler;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AppIcon(
            width: 24,
            height: 24,
            icon: SvgIcons.preferences,
            color: Get.theme.colors().primary,
          ),
          Positioned(
              top: 0,
              right: 0,
              child: Obx(
                () => controler.filterController.hasFilters == true
                    ? Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.white,
                          ),
                          color: Get.theme.colors().lightSecondary,
                          shape: BoxShape.circle,
                        ),
                      )
                    : const SizedBox(),
              )),
        ],
      ),
    );
  }
}
