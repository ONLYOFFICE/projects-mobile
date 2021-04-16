import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/tasks_filter.dart/tasks_filter.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({
    this.controller,
    this.sortButton,
  });
  final BaseController controller;
  final Widget sortButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  controller.screenName,
                  style: TextStyleHelper.headerStyle,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      controller.showSearch();
                    },
                    child: AppIcon(
                      width: 24,
                      height: 24,
                      icon: SvgIcons.search,
                      color: Theme.of(context).customColors().primary,
                    ),
                  ),
                  SizedBox(width: 24),
                  InkWell(
                    onTap: () {
                      Get.bottomSheet(TasksFilter(), isScrollControlled: true);
                    },
                    child: AppIcon(
                      width: 24,
                      height: 24,
                      icon: SvgIcons.preferences,
                      color: Theme.of(context).customColors().primary,
                    ),
                  ),
                  SizedBox(width: 24),
                  InkWell(
                    onTap: () {},
                    child: AppIcon(
                      width: 24,
                      height: 24,
                      icon: SvgIcons.tasklist,
                      color: Theme.of(context).customColors().primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              sortButton,
              Container(
                child: Row(
                  children: <Widget>[
                    Obx(
                      () => Text(
                        'Total ${controller.itemList.length}',
                        style: TextStyleHelper.body2(
                          color: Theme.of(context)
                              .customColors()
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
  }
}
