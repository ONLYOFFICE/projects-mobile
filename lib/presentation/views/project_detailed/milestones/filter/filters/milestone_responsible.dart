part of '../milestones_filter.dart';

class _MilestoneResponsible extends StatelessWidget {
  const _MilestoneResponsible({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<MilestonesFilterController>();
    return Obx(
      () => FiltersRow(
        title: tr('responsible'),
        options: <Widget>[
          FilterElement(
              title: tr('me'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.milestoneResponsible['me'],
              onTap: () => filterController.changeResponsible('me')),
          FilterElement(
            title: filterController.milestoneResponsible['other'].isEmpty
                ? tr('otherUser')
                : filterController.milestoneResponsible['other'],
            isSelected:
                filterController.milestoneResponsible['other'].isNotEmpty,
            cancelButtonEnabled:
                filterController.milestoneResponsible['other'].isNotEmpty,
            onTap: () async {
              var newUser = await Get.find<NavigationController>()
                  .toScreen(const SelectUserScreen());
              await filterController.changeResponsible('other', newUser);
            },
            onCancelTap: () =>
                filterController.changeResponsible('other', null),
          ),
        ],
      ),
    );
  }
}
