import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/customBottomSheet.dart';
import 'package:projects/presentation/shared/widgets/status_tile.dart';

Future<void> showsDiscussionStatusesBS({
  context,
  DiscussionItemController controller,
}) async {
  var initSize = _getInititalSize();
  showCustomBottomSheet(
    context: context,
    headerHeight: 60,
    initHeight: initSize,
    maxHeight: initSize + 0.1,
    decoration: BoxDecoration(
        color: Get.theme.colors().surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
    headerBuilder: (context, bottomSheetOffset) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18.5),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(tr('selectStatus'),
                style: TextStyleHelper.h6(color: Get.theme.colors().onSurface)),
          ),
          const SizedBox(height: 18.5),
        ],
      );
    },
    builder: (context, bottomSheetOffset) {
      return SliverChildListDelegate(
        [
          // Obx(
          //   () =>
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 1,
                    color: Get.theme.colors().outline.withOpacity(0.5)),
              ),
            ),
            child: Obx(
              () => Column(
                children: [
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () async => controller.updateMessageStatus(0),
                    child: StatusTile(
                      title: tr('open'),
                      selected: controller.status.value == 0,
                    ),
                  ),
                  InkWell(
                    onTap: () async => controller.updateMessageStatus(1),
                    child: StatusTile(
                      title: tr('archived'),
                      selected: controller.status.value == 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // ),
        ],
      );
    },
  );
}

double _getInititalSize() => 180 / Get.height;
