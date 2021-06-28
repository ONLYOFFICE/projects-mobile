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

part of 'task_detailed_view.dart';

class _AppBarMenu extends StatelessWidget {
  final TaskItemController controller;
  const _AppBarMenu({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var task = controller.task.value;
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert, size: 26),
      offset: const Offset(0, 25),
      onSelected: (value) => _onSelected(value, controller),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'copyLink',
            child: Text(tr('copyLink')),
          ),
          if (task.canEdit)
            PopupMenuItem(
              value: 'editTask',
              child: Text(tr('editTask')),
            ),
          PopupMenuItem(
            value: 'followTask',
            child:
                Text(task.isSubscribed ? tr('unfollowTask') : tr('followTask')),
          ),
          PopupMenuItem(
            value: 'copyTask',
            child: Text(tr('copyTask')),
          ),
          if (task.canDelete)
            PopupMenuItem(
              textStyle: Theme.of(context)
                  .popupMenuTheme
                  .textStyle
                  .copyWith(color: Theme.of(context).customColors().error),
              value: 'deleteTask',
              child: Text(tr('deleteTask')),
            )
        ];
      },
    );
  }
}

void _onSelected(value, TaskItemController controller) async {
  var task = controller.task.value;
  switch (value) {
    case 'copyLink':
      controller.copyLink(taskId: task.id, projectId: task.projectOwner.id);
      break;

    case 'editTask':
      await Get.toNamed('TaskEditingView',
          arguments: {'task': controller.task.value});
      break;

    case 'followTask':
      var result = await controller.subscribeToTask(taskId: task.id);
      if (result != null) await controller.reloadTask();
      break;

    case 'copyTask':
      await controller.copyTask();
      break;

    case 'deleteTask':
      await Get.dialog(StyledAlertDialog(
        titleText: 'deleteTask',
        contentText: tr('deleteTaskAlert'),
        acceptText: tr('delete').toUpperCase(),
        onCancelTap: () async => Get.back(),
        onAcceptTap: () async {
          var result = await controller.deleteTask(taskId: task.id);
          if (result != null) {
            // ignore: unawaited_futures
            Get.find<TasksController>().loadTasks();
            Get.back();
            Get.back();
          } else {
            print('ERROR');
          }
        },
      ));
      break;
    default:
  }
}
