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
              textStyle: Get.theme.popupMenuTheme.textStyle
                  .copyWith(color: Get.theme.colors().colorError),
              value: 'deleteTask',
              child: Text(tr('deleteTaskButton')),
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
      Get.find<NavigationController>().navigateToFullscreen(
          const TaskEditingView(),
          arguments: {'task': controller.task.value});
      break;

    case 'followTask':
      var result = await controller.subscribeToTask(taskId: task.id);
      if (result) await controller.reloadTask();
      break;

    case 'copyTask':
      await controller.copyTask();
      break;

    case 'deleteTask':
      await Get.dialog(StyledAlertDialog(
        titleText: tr('deleteTaskTitle'),
        contentText: tr('deleteTaskAlert'),
        acceptText: tr('delete').toUpperCase(),
        onCancelTap: () async => Get.back(),
        onAcceptTap: () async {
          var result = await controller.deleteTask(taskId: task.id);
          if (result) {
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
