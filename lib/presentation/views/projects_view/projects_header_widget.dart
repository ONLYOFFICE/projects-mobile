import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/views/projects_view/project_filter/projects_filter.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key key,
    this.controller,
    this.sortButton,
  }) : super(key: key);
  final controller;
  final Widget sortButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
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
                  const SizedBox(width: 24),
                  InkWell(
                    onTap: () async => showFilters(context),
                    child: FiltersButton(controler: controller),
                  ),
                  const SizedBox(width: 24),
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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
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
                        'Total ${controller.paginationController.total.value}',
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
