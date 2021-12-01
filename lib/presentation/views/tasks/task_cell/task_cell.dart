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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';

import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/constants.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/utils/image_decoder.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/cell_atributed_title.dart';
import 'package:projects/presentation/views/task_detailed/task_detailed_view.dart';

part 'status_image.dart';

class TaskCell extends StatefulWidget {
  final PortalTask task;
  const TaskCell({Key? key, required this.task}) : super(key: key);

  @override
  _TaskCellState createState() => _TaskCellState();
}

class _TaskCellState extends State<TaskCell> {
  late TaskItemController itemController;

  @override
  void initState() {
    itemController = Get.put(
      TaskItemController(widget.task),
      tag: widget.task.id.toString(),
    );
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) async => await itemController.initTaskStatus(widget.task));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.find<NavigationController>()
          .to(TaskDetailedView(), arguments: {'controller': itemController}),
      child: SizedBox(
        height: 72,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _StatusImage(controller: itemController),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _SecondColumn(itemController: itemController),
                        const SizedBox(width: 8),
                        _ThirdColumn(controller: itemController),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TaskItemController? controller;

  bool get _loading =>
      controller!.isStatusLoaded.isFalse ||
      controller?.status.value.isNull != false;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_loading) return const SizedBox();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Get.width * 0.25),
              child: Text(controller!.status.value.title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.status(
                      color: controller!.getStatusTextColor)),
            ),
            Text(' • ',
                style: TextStyleHelper.caption(
                    color: Get.theme.colors().onSurface.withOpacity(0.6))),
          ],
        );
      },
    );
  }
}

// refactor
class _SecondColumn extends StatelessWidget {
  final TaskItemController? itemController;

  const _SecondColumn({
    Key? key,
    required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CellAtributedTitle(
                text: itemController!.task.value.title,
                style: TextStyleHelper.projectTitle,
                atributeIcon: AppIcon(icon: SvgIcons.high_priority),
                atributeIconVisible: itemController!.task.value.priority == 1,
              ),
              Wrap(
                children: [
                  _StatusText(controller: itemController),
                  Text(
                    itemController!.displayName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleHelper.caption(
                      color: Get.theme.colors().onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThirdColumn extends StatelessWidget {
  final TaskItemController? controller;

  const _ThirdColumn({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _now = DateTime.now();

    DateTime? _deadline;
    if (controller!.task.value.deadline != null)
      _deadline = DateTime.parse(controller!.task.value.deadline!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_deadline != null)
          Text(
              formatedDateFromString(
                now: _now,
                stringDate: controller!.task.value.deadline!,
              ),
              style: _deadline.isBefore(_now)
                  ? TextStyleHelper.caption(
                      color: Get.theme.colors().colorError)
                  : TextStyleHelper.caption(
                      color: Get.theme.colors().onSurface)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppIcon(icon: SvgIcons.subtasks, color: const Color(0xff666666)),
            const SizedBox(width: 5),
            Text(controller!.task.value.subtasks!.length.toString(),
                style: TextStyleHelper.body2(
                    color: Get.theme.colors().onSurface.withOpacity(0.6))),
          ],
        ),
      ],
    );
  }
}
