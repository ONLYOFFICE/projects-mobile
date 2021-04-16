import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/tasks/sort_controller.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/tasks_filter.dart/tasks_filter.dart';
import 'package:projects/presentation/views/tasks/tasks_sort.dart';
import 'package:projects/presentation/shared/custom_theme.dart';

class HeaderWidget extends StatefulWidget {
  final BaseController controller;
  HeaderWidget({this.controller});

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sortController = Get.find<TasksSortController>();
    return Obx(
      () => Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.controller.screenName,
                    style: TextStyleHelper.headerStyle,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        widget.controller.showSearch();
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
                        Get.bottomSheet(TasksFilter(),
                            isScrollControlled: true);
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
                    // IconButton(
                    //     icon: const Icon(Icons.more_vert_outlined),
                    //     onPressed: () {}),
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
                Container(
                  padding: EdgeInsets.only(right: 4),
                  child: GestureDetector(
                    onTap: () {
                      Get.bottomSheet(TasksSort(), isScrollControlled: true);
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          sortController.currentSort.value,
                          style: TextStyleHelper.projectsSorting,
                        ),
                        const SizedBox(width: 8),
                        SVG.createSized(
                            'lib/assets/images/icons/sorting_3_descend.svg',
                            20,
                            20),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Obx(
                        () => Text(
                          '${widget.controller.itemList.length} ${widget.controller.screenName.toLowerCase()}',
                          style: TextStyleHelper.subtitleProjects,
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
      ),
    );
  }
}
