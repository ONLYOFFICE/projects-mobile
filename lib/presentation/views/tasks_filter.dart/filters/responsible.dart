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
                  title: filterController.responsible['Other'].isEmpty
                      ? 'Other user'
                      : filterController.responsible['Other'],
                  selected: filterController.responsible['Other'].isNotEmpty,
                  cancelButton:
                      filterController.responsible['Other'].isNotEmpty,
                  onTap: () async {
                    var newUser = await Get.bottomSheet(const SelectUser());
                    filterController.changeResponsible('Other', newUser);
                  },
                  onCancelTap: () =>
                      filterController.changeResponsible('Other', null)),
              _FilterElement(
                  title: filterController.responsible['Groups'].isEmpty
                      ? 'Groups'
                      : filterController.responsible['Groups'],
                  selected: filterController.responsible['Groups'].isNotEmpty,
                  cancelButton:
                      filterController.responsible['Groups'].isNotEmpty,
                  onTap: () async {
                    var newGroup = await Get.bottomSheet(const SelectGroup());
                    filterController.changeResponsible('Groups', newGroup);
                  },
                  onCancelTap: () =>
                      filterController.changeResponsible('Groups', null)),
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
