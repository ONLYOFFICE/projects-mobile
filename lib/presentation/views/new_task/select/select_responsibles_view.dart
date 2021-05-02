import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';

class SelectResponsiblesView extends StatelessWidget {
  const SelectResponsiblesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usersDataSource = Get.find<UsersDataSource>();
    var controller = Get.arguments['controller'];

    controller.setupResponsiblesSelection();

    usersDataSource.multipleSelectionEnabled = true;
    return Scaffold(
      appBar: StyledAppBar(
          title: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select responsibles'),
                if (controller.responsibles.isNotEmpty)
                  Text('${controller.responsibles.length} users selected',
                      style: TextStyleHelper.caption())
              ],
            ),
          ),
          bottom: SearchField(
            hintText: 'Search for users',
            onSubmitted: (value) => usersDataSource.searchUsers(value),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.check_rounded),
                onPressed: () => controller.confirmResponsiblesSelection())
          ],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => controller.leaveResponsiblesSelectionView())),
      body: Obx(
        () {
          if (usersDataSource.loaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isFalse) {
            return UsersDefault(
              selfUserItem: controller.selfUserItem,
              usersDataSource: usersDataSource,
              onTapFunction: controller.addResponsible,
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
              onTapFunction: () => controller.addResponsible,
            );
          }
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}
