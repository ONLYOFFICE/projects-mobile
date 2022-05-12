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
  const _AppBarMenu({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = controller.task.value;
    return PlatformPopupMenuButton(
      padding: EdgeInsets.zero,
      icon: PlatformIconButton(
        padding: EdgeInsets.zero,
        cupertinoIcon: Icon(
          CupertinoIcons.ellipsis_circle,
          color: Theme.of(context).colors().primary,
        ),
        materialIcon: Icon(
          Icons.more_vert,
          color: Theme.of(context).colors().primary,
        ),
      ),
      onSelected: (dynamic value) => _onSelected(value, controller),
      itemBuilder: (context) {
        return [
          if (controller.canEdit && task.responsibles!.isEmpty)
            PlatformPopupMenuItem(
              value: 'accept',
              child: Text(tr('acceptTask')),
            ),
          PlatformPopupMenuItem(
            value: 'copyLink',
            child: Text(tr('copyLink')),
          ),
          if (controller.canEdit)
            PlatformPopupMenuItem(
              value: 'editTask',
              child: Text(tr('editTask')),
            ),
          PlatformPopupMenuItem(
            value: 'followTask',
            child: Text((task.isSubscribed ?? false) ? tr('unfollowTask') : tr('followTask')),
          ),
          if (controller.canEdit)
            PlatformPopupMenuItem(
              value: 'copyTask',
              child: Text(tr('copyTask')),
            ),
          if (task.canDelete!)
            PlatformPopupMenuItem(
              textStyle: Theme.of(context)
                  .popupMenuTheme
                  .textStyle
                  ?.copyWith(color: Theme.of(context).colors().colorError),
              isDestructiveAction: true,
              value: 'deleteTask',
              child: Text(tr('deleteTaskButton')),
            )
        ];
      },
    );
  }
}

void _onSelected(value, TaskItemController controller) async {
  final task = controller.task.value;
  switch (value) {
    case 'accept':
      await controller.accept();
      break;

    case 'copyLink':
      await controller.copyLink(taskId: task.id!, projectId: task.projectOwner!.id!);
      break;

    case 'editTask':
      unawaited(
        Get.find<NavigationController>().toScreen(
          const TaskEditingView(),
          transition: Transition.cupertinoDialog,
          fullscreenDialog: true,
          arguments: {'task': controller.task.value},
          page: '/TaskEditingView',
        ),
      );
      break;

    case 'followTask':
      final result = await controller.subscribeToTask(taskId: task.id!);
      if (result) await controller.reloadTask();
      break;

    case 'copyTask':
      await controller.copyTask();
      break;

    case 'deleteTask':
      await Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('deleteTaskTitle'),
        contentText: tr('deleteTaskAlert'),
        acceptText: tr('delete').toUpperCase(),
        acceptColor: Theme.of(Get.context!).colors().colorError,
        onCancelTap: () async => Get.back(),
        onAcceptTap: () async {
          final result = await controller.deleteTask(taskId: task.id!);
          if (result) {
            locator<EventHub>().fire('needToRefreshTasks', {'all': true});

            Get.back();
            Get.back();

            MessagesHandler.showSnackBar(context: Get.context!, text: tr('taskDeleted'));
          } else
            MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
        },
      ));
      break;
    default:
  }
}
