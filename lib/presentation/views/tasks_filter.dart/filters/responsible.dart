part of '../tasks_filter.dart';

class _Responsible extends StatelessWidget {
  const _Responsible({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FilterLabel(
              label: 'Responsible',
              padding: EdgeInsets.only(left: 16, bottom: 20.05)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              _FilterElement(
                  title: 'Me',
                  selected: filterController.responsible['Me'],
                  onTap: () => filterController.changeResponsible('Me')),
              _FilterElement(
                  title: filterController.responsible['Other'] != ''
                      ? filterController.responsible['Other']
                      : 'Other user',
                  selected: filterController.responsible['Other'] != '',
                  onTap: () async {
                    var newUser = await Get.bottomSheet(SelectUser());
                    filterController.changeResponsible('Other', newUser);
                  },
                  cancelButton: true,
                  onCancelTap: () =>
                      filterController.changeResponsible('Other', null)),
              _FilterElement(
                  title: 'Groups',
                  selected: filterController.responsible['Groups'] != '',
                  onTap: () => filterController.changeResponsible('Groups')),
              _FilterElement(
                  title: 'No responsible',
                  titleColor: Theme.of(context).customColors().onSurface,
                  selected: filterController.responsible['No'],
                  onTap: () => filterController.changeResponsible('No'))
            ]),
          ),
        ],
      ),
    );
  }
}
