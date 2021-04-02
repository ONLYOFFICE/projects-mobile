part of '../tasks_filter.dart';

class _Creator extends StatelessWidget {
  const _Creator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FilterLabel(label: 'Creator'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              _FilterElement(
                  title: 'Me',
                  titleColor: Theme.of(context).customColors().onSurface,
                  selected: filterController.creator['Me'],
                  onTap: () => filterController.changeCreator('Me')),
              _FilterElement(
                title: filterController.creator['Other'] != ''
                    ? filterController.creator['Other']
                    : 'Other user',
                selected: filterController.creator['Other'] != '',
                cancelButton: true,
                onTap: () async {
                  var newUser = await Get.bottomSheet(SelectUser());
                  filterController.changeCreator('Other', newUser);
                },
                onCancelTap: () =>
                    filterController.changeCreator('Other', null),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
