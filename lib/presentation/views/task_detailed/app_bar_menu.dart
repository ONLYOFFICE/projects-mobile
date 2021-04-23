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
          const PopupMenuItem(value: 'Copy link', child: Text('Copy link')),
          if (task.canEdit)
            const PopupMenuItem(value: 'Edit task', child: Text('Edit task')),
          PopupMenuItem(
              value: 'Follow task',
              child: Text(task.isSubscribed ? 'Unfollow task' : 'Follow task')),
          const PopupMenuItem(child: Text('Copy task')),
          if (task.canDelete)
            PopupMenuItem(
              textStyle: Theme.of(context)
                  .popupMenuTheme
                  .textStyle
                  .copyWith(color: Theme.of(context).customColors().error),
              value: 'Delete task',
              child: const Text('Delete task'),
            )
        ];
      },
    );
  }
}

void _onSelected(value, TaskItemController controller) async {
  var task = controller.task.value;
  switch (value) {
    case 'Delete task':
      await Get.dialog(StyledAlertDialog(
        titleText: 'Delete task',
        contentText:
            // ignore: lines_longer_than_80_chars
            'Are you sure you want to delete these task?\nNote: this action cannot be undone.',
        acceptText: 'DELETE',
        onAcceptTap: () async {
          var result = await controller.deleteTask(taskId: task.id);
          if (result != null) {
            // ignore: unawaited_futures
            Get.find<TasksController>().reloadTasks();
            Get.back();
            Get.back();
          } else {
            print('ERROR');
          }
        },
      ));
      break;
    case 'Copy link':
      var taskId = task.id;
      var prjId = task.projectOwner.id;
      var link =
          'https://alexanderyuzhin.teamlab.info/Products/Projects/Tasks.aspx?prjID=$prjId&id=$taskId#';
      await Clipboard.setData(ClipboardData(text: link));
      break;
    case 'Follow task':
      var result = await controller.subscribeToTask(taskId: task.id);
      if (result != null) await controller.reloadTask();
      break;
    default:
  }
}
