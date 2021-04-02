import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/tasks/sort_controller.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/views/tasks_filter.dart/tasks_filter.dart';
import 'package:projects/presentation/views/tasks/tasks_sort.dart';

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
            padding: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 56,
                  child: SVG.createSized(
                      'lib/assets/images/icons/project_icon.svg', 40, 40),
                ),
                Expanded(
                  child: Text(
                    widget.controller.screenName,
                    style: TextStyleHelper.headerStyle,
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          widget.controller.showSearch();
                        },
                      ),
                      IconButton(
                          icon: SVG.create(
                              'lib/assets/images/icons/preferences.svg'),
                          onPressed: () {
                            Get.bottomSheet(TasksFilter(),
                                isScrollControlled: true);
                          }),
                      IconButton(
                          icon: const Icon(Icons.more_vert_outlined),
                          onPressed: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // const SizedBox(width: 16),
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
