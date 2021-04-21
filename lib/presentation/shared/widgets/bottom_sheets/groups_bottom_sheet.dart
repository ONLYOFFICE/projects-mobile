import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/groups_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';

class GroupsBottomSheet extends StatelessWidget {
  const GroupsBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _groupsController = Get.find<GroupsController>();

    _groupsController.getAllGroups();

    return StyledButtomSheet(
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select group', style: TextStyleHelper.h6()),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => print(''),
                )
              ],
            ),
          ),
          Divider(height: 1),
          Obx(() {
            if (_groupsController.loaded.isTrue) {
              return Expanded(
                child: ListView.separated(
                  itemCount: _groupsController.groups.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      child: InkWell(
                        onTap: () => Get.back(result: {
                          'id': _groupsController.groups[index].id,
                          'name': _groupsController.groups[index].name
                        }),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Flexible(
                                      child: Text(
                                          _groupsController.groups[index].name,
                                          style: TextStyleHelper.projectTitle)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return ListLoadingSkeleton();
            }
          })
        ],
      ),
    );
  }
}
