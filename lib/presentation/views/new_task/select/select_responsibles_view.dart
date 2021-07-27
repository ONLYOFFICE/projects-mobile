import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
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

    usersDataSource.selectionMode = UserSelectionMode.Multiple;
    return Scaffold(
      appBar: StyledAppBar(
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr('selectResponsibles')),
              if (controller.responsibles.isNotEmpty)
                Text(plural('usersSelected', controller.responsibles.length),
                    // '${controller.responsibles.length} users selected',
                    style: TextStyleHelper.caption())
            ],
          ),
        ),
        bottom: SearchField(
          hintText: tr('searchUsers'),
          onSubmitted: (value) => usersDataSource.searchUsers(value),
        ),
        onLeadingPressed: controller.leaveResponsiblesSelectionView,
        actions: [
          IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: controller.confirmResponsiblesSelection)
        ],
      ),
      body: Obx(
        () {
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.value == false) {
            return UsersDefault(
              selfUserItem: controller.selfUserItem,
              usersDataSource: usersDataSource,
              onTapFunction: controller.addResponsible,
            );
          }
          if (usersDataSource.nothingFound.value == true) {
            return const NothingFound();
          }
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.value == true) {
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
