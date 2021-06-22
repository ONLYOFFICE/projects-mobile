import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectDiscussionSubscribers extends StatelessWidget {
  const SelectDiscussionSubscribers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usersDataSource = Get.find<UsersDataSource>();
    DiscussionActionsController controller = Get.arguments['controller'];

    controller.setupSubscribersSelection();

    return Scaffold(
      appBar: StyledAppBar(
        // titleText: 'Select subscribers',
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select subscribers'),
              if (controller.subscribers.isNotEmpty)
                Text('${controller.subscribers.length} users selected',
                    style: TextStyleHelper.caption())
            ],
          ),
        ),
        onLeadingPressed: controller.leaveSubscribersSelectionView,
        actions: [
          IconButton(
              onPressed: controller.confirmSubscribersSelection,
              icon: const Icon(Icons.done))
        ],
        // bottom: CustomSearchBar(controller: controller),
        bottom: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(() => Expanded(
                  child: SearchField(
                    hintText: 'Search for users...',
                    onChanged: usersDataSource.searchUsers,
                    showClearIcon: usersDataSource.isSearchResult.isTrue,
                    onClearPressed: controller.clearUserSearch,
                    controller: controller.userSearchController,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.5, right: 16),
              child: InkResponse(
                onTap: () => Get.toNamed('UsersFromGroups',
                    arguments: {'controller': controller}),
                child: AppIcon(icon: SvgIcons.preferences),
              ),
            )
          ],
        ),
      ),
      body: Obx(
        () {
          if (usersDataSource.loaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isFalse) {
            // return UsersDefault(
            //   selfUserItem: controller.selfUserItem,
            //   usersDataSource: usersDataSource,
            //   onTapFunction: () => controller.addResponsible,
            // );
            return SmartRefresher(
              enablePullDown: false,
              controller: usersDataSource.refreshController,
              onLoading: usersDataSource.onLoading,
              enablePullUp: usersDataSource.pullUpEnabled,
              child: ListView.separated(
                itemCount: usersDataSource.usersList.length,
                padding: const EdgeInsets.symmetric(vertical: 13),
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 24);
                },
                itemBuilder: (BuildContext context, int index) {
                  return Obx(
                    () => CheckboxListTile(
                      value:
                          usersDataSource.usersList[index].isSelected == true,
                      onChanged: (value) {
                        usersDataSource.usersList[index].onTap();
                        controller
                            .addSubscriber(usersDataSource.usersList[index]);
                      },
                      contentPadding: const EdgeInsets.only(left: 16, right: 9),
                      title: Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CustomNetworkImage(
                                image: usersDataSource
                                        .usersList[index].portalUser.avatar ??
                                    usersDataSource.usersList[index].portalUser
                                        .avatarMedium ??
                                    usersDataSource.usersList[index].portalUser
                                        .avatarSmall,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  usersDataSource.usersList[index].displayName,
                                  maxLines: 2,
                                  style: TextStyleHelper.subtitle1(
                                      color: Theme.of(context)
                                          .customColors()
                                          .onSurface),
                                ),
                                if (usersDataSource
                                        .usersList[index].portalUser.title !=
                                    null)
                                  Text(
                                    usersDataSource
                                        .usersList[index].portalUser.title,
                                    maxLines: 2,
                                    style: TextStyleHelper.caption(
                                        color: Theme.of(context)
                                            .customColors()
                                            .onSurface
                                            .withOpacity(0.6)),
                                  ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          if (usersDataSource.nothingFound.isTrue) {
            return const NothingFound();
          }
          if (usersDataSource.loaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isTrue) {
            return UsersSearchResult(
              usersDataSource: usersDataSource,
              onTapFunction: controller.addSubscriber,
            );
          }
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}
