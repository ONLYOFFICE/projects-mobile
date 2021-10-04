part of 'task_cell.dart';

class _StatusImage extends StatelessWidget {
  const _StatusImage({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TaskItemController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isStatusLoaded.isFalse) return const _StatusLoadingIcon();
      return GestureDetector(
        onTap: () async => controller.openStatuses(context),
        child: SizedBox(
          width: 72,
          child: SizedBox(
            height: 40,
            width: 40,
            child: Padding(
              padding: const EdgeInsets.all(0.5),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.getStatusBGColor,
                ),
                child: StatusIcon(
                  canEditTask: controller.task.value.canEdit,
                  status: controller.status.value,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class StatusIcon extends StatelessWidget {
  const StatusIcon({
    Key key,
    @required this.canEditTask,
    @required this.status,
  }) : super(key: key);

  final bool canEditTask;
  final Status status;

  @override
  Widget build(BuildContext context) {
    if (!Const.standartTaskStatuses.containsKey(status.id)) {
      return Center(
          child: SVG.createSizedFromString(
              decodeImageString(status?.image),
              16,
              16,
              canEditTask
                  ? status?.color?.toColor() ?? Get.theme.colors().primary
                  : Get.theme.colors().onBackground.withOpacity(0.6)));
    }
    if (Const.standartTaskStatuses.containsKey(status.id)) {
      return Center(
          child: AppIcon(
              icon: Const.standartTaskStatuses[status.id],
              color: canEditTask
                  ? Get.theme.colors().primary
                  : Get.theme.colors().onBackground.withOpacity(0.6)));
    }
    throw Exception('STATUS ERROR');
  }
}

class _StatusLoadingIcon extends StatelessWidget {
  const _StatusLoadingIcon({
    Key key,
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
              child: CircularProgressIndicator(
                color: Get.theme.colors().primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
