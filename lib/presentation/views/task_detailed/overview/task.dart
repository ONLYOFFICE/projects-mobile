part of 'tasks_overview_screen.dart';

class _Task extends StatelessWidget {
  final TaskItemController taskController;

  const _Task({Key key, @required this.taskController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(72, 20, 16, 16),
      child: Obx(
        () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TASK', style: TextStyleHelper.overline()),
              Text(taskController.task.value.title,
                  style: TextStyleHelper.headline6(
                      color: Theme.of(context).customColors().onSurface)),
              const SizedBox(height: 22),
              StatusButton(
                  text: taskController.status.value.title,
                  onPressed: () => taskController.tryChangingStatus(context)),
            ],
          );
        },
      ),
    );
  }
}
