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
          const PopupMenuItem(value: 'Copy task', child: Text('Copy task')),
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
    case 'Copy link':
      controller.copyLink(taskId: task.id, projectId: task.projectOwner.id);
      break;

    case 'Edit task':
      await Get.toNamed('TaskEditingView',
          arguments: {'task': controller.task.value});
      break;

    case 'Follow task':
      var result = await controller.subscribeToTask(taskId: task.id);
      if (result != null) await controller.reloadTask();
      break;

    case 'Copy task':
      await controller.copyTask();
      break;

    case 'Delete task':
      await Get.dialog(StyledAlertDialog(
        titleText: 'Delete task',
        contentText:
            // ignore: lines_longer_than_80_chars
            'Are you sure you want to delete these task?\nNote: this action cannot be undone.',
        acceptText: 'DELETE',
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
