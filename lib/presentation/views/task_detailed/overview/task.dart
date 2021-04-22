part of 'overview_screen.dart';

class Task extends StatelessWidget {
  final TaskItemController taskController;

  const Task({Key key, @required this.taskController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(56, 20, 16, 16),
      child: Obx(
        () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TASK', style: TextStyleHelper.overline),
              Text(taskController.task.value.title,
                  style: TextStyleHelper.headline6(
                      color: Theme.of(context).customColors().onSurface)),
              const SizedBox(height: 22),
              OutlinedButton(
                onPressed: () => bottom_sheet.showsStatusesBS(
                    context: context, taskItemController: taskController),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((_) {
                    return const Color(0xff81C4FF).withOpacity(0.1);
                  }),
                  side: MaterialStateProperty.resolveWith((_) {
                    return const BorderSide(
                        color: Color(0xff0C76D5), width: 1.5);
                  }),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(taskController.status.value.title,
                            style: TextStyleHelper.subtitle2()),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down_sharp)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
