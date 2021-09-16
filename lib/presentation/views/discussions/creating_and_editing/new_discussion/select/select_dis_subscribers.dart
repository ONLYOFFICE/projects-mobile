import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/users_from_groups.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectDiscussionSubscribers extends StatelessWidget {
  const SelectDiscussionSubscribers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usersDataSource = Get.find<UsersDataSource>();
    DiscussionActionsController controller = Get.arguments['controller'];

    controller.setupSubscribersSelection();

    final platformController = Get.find<PlatformController>();

    return WillPopScope(
      onWillPop: () async {
        controller.leaveSubscribersSelectionView();
        return false;
      },
      child: Scaffold(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        appBar: StyledAppBar(
          backgroundColor:
              platformController.isMobile ? null : Get.theme.colors().surface,
          // titleText: 'Select subscribers',
          backButtonIcon: Get.put(PlatformController()).isMobile
              ? const Icon(Icons.arrow_back_rounded)
              : const Icon(Icons.close),
          title: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr('selectSubscribers')),
                if (controller.subscribers.isNotEmpty)
                  Text(plural('selected', controller.subscribers.length),
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
                      hintText: tr('usersSearch'),
                      onSubmitted: usersDataSource.searchUsers,
                      showClearIcon:
                          usersDataSource.isSearchResult.value == true,
                      onClearPressed: controller.clearUserSearch,
                      controller: controller.userSearchController,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.5, right: 16),
                child: InkResponse(
                  onTap: () => Get.find<NavigationController>().to(
                      const UsersFromGroups(),
                      arguments: {'controller': controller}),
                  child: AppIcon(icon: SvgIcons.preferences),
                ),
              )
            ],
          ),
        ),
        body: Obx(
          () {
            if (usersDataSource.loaded.value == true &&
                usersDataSource.usersList.isNotEmpty &&
                usersDataSource.isSearchResult.value == false) {
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
                          controller.addSubscriber(
                            usersDataSource.usersList[index],
                            fromUsersDataSource: true,
                          );
                        },
                        contentPadding:
                            const EdgeInsets.only(left: 16, right: 9),
                        title: Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundColor:
                                    Get.theme.colors().bgDescription,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Obx(() {
                                    return usersDataSource
                                        .usersList[index].avatar.value;
                                  }),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    usersDataSource
                                        .usersList[index].displayName,
                                    maxLines: 2,
                                    style: TextStyleHelper.subtitle1(
                                        color: Get.theme.colors().onSurface),
                                  ),
                                  if (usersDataSource
                                          .usersList[index].portalUser.title !=
                                      null)
                                    Text(
                                      usersDataSource
                                          .usersList[index].portalUser.title,
                                      maxLines: 2,
                                      style: TextStyleHelper.caption(
                                          color: Get.theme
                                              .colors()
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
            if (usersDataSource.nothingFound.value == true) {
              return Column(children: [const NothingFound()]);
            }
            if (usersDataSource.loaded.value == true &&
                usersDataSource.usersList.isNotEmpty &&
                usersDataSource.isSearchResult.value == true) {
              return UsersSearchResult(
                usersDataSource: usersDataSource,
                onTapFunction: controller.addSubscriber,
              );
            }
            return const ListLoadingSkeleton();
          },
        ),
      ),
    );
  }
}
