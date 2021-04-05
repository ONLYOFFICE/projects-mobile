import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/domain/controllers/users/users_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';

class SelectUser extends StatelessWidget {
  const SelectUser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _usersController = Get.find<UsersController>();

    _usersController.getAllProfiles();

    return StyledButtomSheet(
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select user', style: TextStyleHelper.h6()),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => print(''),
                )
              ],
            ),
          ),
          Divider(),
          Obx(() {
            if (_usersController.loaded.isTrue) {
              return Expanded(
                child: ListView.separated(
                  itemCount: _usersController.users.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      child: InkWell(
                        onTap: () => Get.back(result: {
                          'id': _usersController.users[index].id,
                          'displayName':
                              _usersController.users[index].displayName
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
                                          _usersController
                                              .users[index].displayName,
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
      // content: Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text('Select user', style: TextStyleHelper.h6()),
      //           IconButton(
      //             icon: Icon(Icons.search),
      //             onPressed: () => print(''),
      //           )
      //         ],
      //       ),
      //     ),
      //     Divider(),
      //     Obx(
      //       () {
      //         if (_projectsController.loaded.isTrue) {
      //           return Expanded(
      //             child: ListView.separated(
      //               itemCount: _projectsController.projects.length,
      //               padding: const EdgeInsets.only(bottom: 16),
      //               separatorBuilder: (BuildContext context, int index) {
      //                 return Divider();
      //               },
      //               itemBuilder: (BuildContext context, int index) {
      //                 return Material(
      // child: InkWell(
      //   onTap: () => Get.back(result: {
      //     'id': _projectsController.projects[index].id,
      //     'title': _projectsController.projects[index].title
      //   }),
      //   child: Container(
      //     margin: const EdgeInsets.symmetric(
      //         horizontal: 16, vertical: 8),
      //     child: Row(
      //       children: [
      //         Flexible(
      //           child: Column(
      //             crossAxisAlignment:
      //                 CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 _projectsController
      //                     .projects[index].title,
      //                 style: TextStyleHelper.projectTitle,
      //               ),
      //               Text(
      //                   _projectsController.projects[index]
      //                       .responsible.displayName,
      //                   style: TextStyleHelper.caption(
      //                           color: Theme.of(context)
      //                               .customColors()
      //                               .onSurface
      //                               .withOpacity(0.6))
      //                       .copyWith(height: 1.667)),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // );
      //               },
      //             ),
      //           );
      //         } else {
      //           return ListLoadingSkeleton();
      //         }
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}
