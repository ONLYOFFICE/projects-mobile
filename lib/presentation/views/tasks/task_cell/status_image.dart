/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

part of 'task_cell.dart';

class _StatusImage extends StatelessWidget {
  const _StatusImage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TaskItemController? controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller!.isStatusLoaded.isFalse) return const _StatusLoadingIcon();
      return GestureDetector(
        onTap: () async => controller!.openStatuses(context),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              SizedBox(
                height: 44,
                width: 44,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller!.getStatusBGColor,
                  ),
                  child: StatusIcon(
                    canEditTask: controller!.task.value.canEdit!,
                    status: controller!.status.value,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ]),
      );
    });
  }
}

class StatusIcon extends StatelessWidget {
  const StatusIcon({
    Key? key,
    required this.canEditTask,
    required this.status,
  }) : super(key: key);

  final bool canEditTask;
  final Status status;

  @override
  Widget build(BuildContext context) {
    if (!Const.standartTaskStatuses.containsKey(status.id)) {
      return Center(
          child: SVG.createSizedFromString(
              decodeImageString(status.image!),
              16,
              16,
              canEditTask
                  ? status.color?.toColor() ?? Get.theme.colors().primary
                  : Get.theme.colors().onBackground.withOpacity(0.6)));
    }
    if (Const.standartTaskStatuses.containsKey(status.id)) {
      return Center(
        child: AppIcon(
            icon: Const.standartTaskStatuses[status.id!],
            color: canEditTask
                ? Get.theme.colors().primary
                : Get.theme.colors().onBackground.withOpacity(0.6)),
      );
    }
    throw Exception('STATUS ERROR');
  }
}

class _StatusLoadingIcon extends StatelessWidget {
  const _StatusLoadingIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: SizedBox(
        height: 40,
        width: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Get.theme.colors().onBackground.withOpacity(0.05),
          ),
          child: Center(
            child: SizedBox(
              height: 16,
              width: 16,
              child: PlatformCircularProgressIndicator(
                color: Get.theme.colors().primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
