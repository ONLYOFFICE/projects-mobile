import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';

class HeaderFilterView extends StatelessWidget {
  const HeaderFilterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 4,
                  width: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 16, top: 6),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              size: 26,
                              color: Theme.of(context).customColors().primary,
                            ),
                            onPressed: () => Get.back(),
                          ),
                          const SizedBox(width: 10),
                          Text('Filter',
                              style: TextStyleHelper.h6(
                                  color: Theme.of(context)
                                      .customColors()
                                      .onSurface))
                        ],
                      ),
                      TextButton(
                          onPressed: () => print('ok'),
                          child: Text('RESET',
                              style: TextStyleHelper.button(
                                  color: Theme.of(context)
                                      .customColors()
                                      .systemBlue)))
                    ])),
            const Divider(height: 18),
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
                    title: 'Other user',
                    selected: filterController.responsible['Other'],
                    onTap: () => filterController.changeResponsible('Other')),
                _FilterElement(
                    title: 'Groups',
                    selected: filterController.responsible['Groups'],
                    onTap: () => filterController.changeResponsible('Groups')),
                _FilterElement(
                    title: 'No responsible',
                    titleColor: Theme.of(context).customColors().onSurface,
                    selected: filterController.responsible['No responsible'],
                    onTap: () =>
                        filterController.changeResponsible('No responsible'))
                // onTap: () =>
                //     filterController.responsible['No responsible'] =
                //         !filterController.responsible['No responsible'])
              ]),
            ),
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
                    title: 'Other user',
                    selected: filterController.creator['Other'],
                    onTap: () => filterController.changeCreator('Other'))
              ]),
            ),
            const _FilterLabel(label: 'Project'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(runSpacing: 16, spacing: 16, children: [
                _FilterElement(
                    title: 'My projects',
                    titleColor: Theme.of(context).customColors().onSurface,
                    selected: filterController.project['My'],
                    onTap: () => filterController.changeProject('My')),
                _FilterElement(
                    title: 'Other projects',
                    selected: filterController.project['Other'],
                    onTap: () => filterController.changeProject('Other')),
                _FilterElement(
                    title: 'With tag',
                    selected: filterController.project['With tag'],
                    onTap: () => filterController.changeProject('With tag')),
                _FilterElement(
                    title: 'Without tag',
                    selected: filterController.project['Without tag'],
                    onTap: () => filterController.changeProject('Without tag')),
              ]),
            ),
            const _FilterLabel(label: 'Milestone'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(runSpacing: 16, spacing: 16, children: [
                _FilterElement(
                    title: 'Milestones with my tasks',
                    titleColor: Theme.of(context).customColors().onSurface,
                    selected: filterController.milestone['My'],
                    onTap: () => filterController.changeMilestone('My')),
                _FilterElement(
                    title: 'No milestone',
                    titleColor: Theme.of(context).customColors().onSurface,
                    selected: filterController.milestone['No'],
                    onTap: () => filterController.changeMilestone('No')),
                _FilterElement(
                    title: 'Other milestones',
                    selected: filterController.milestone['Other'],
                    onTap: () => filterController.changeMilestone('Other')),
              ]),
            ),
            if (filterController.suitableTasksCount.value != -1)
              Center(
                child: TextButton(
                  onPressed: () async {
                    filterController.filter();
                    Get.back();
                  },
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                              (_) => EdgeInsets.only(
                                  left: Get.width * 0.243,
                                  right: Get.width * 0.243,
                                  top: 10,
                                  bottom: 12)),
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((_) {
                        return Theme.of(context).customColors().primary;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)))),
                  child: Text(
                      'SHOW ${filterController.suitableTasksCount.value} TASK',
                      style: TextStyleHelper.button(
                          color: Theme.of(context).customColors().onPrimary)),
                ),
              ),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}

class _FilterLabel extends StatelessWidget {
  final String label;
  final EdgeInsets padding;
  const _FilterLabel({
    Key key,
    this.label,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding ??
            const EdgeInsets.only(left: 16, top: 36.5, bottom: 20.05),
        child: Text(label,
            style: TextStyleHelper.h6(
                color: Theme.of(context).customColors().onSurface)));
  }
}

class _FilterElement extends StatelessWidget {
  final bool selected;
  final String title;
  final Color titleColor;
  final Function() onTap;

  const _FilterElement(
      {Key key, this.selected = false, this.title, this.titleColor, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.only(top: 5, bottom: 6, left: 12, right: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffD8D8D8), width: 0.5),
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? Theme.of(context).customColors().primary
              : Theme.of(context).customColors().bgDescription,
        ),
        child: Text(
          title,
          style: TextStyleHelper.body2(
              color: selected
                  ? Theme.of(context).customColors().onPrimarySurface
                  : titleColor ?? Theme.of(context).customColors().primary),
        ),
      ),
    );
  }
}
