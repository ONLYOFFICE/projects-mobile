import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_search_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/internal/utils/name_formatter.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectProjectScreen extends StatelessWidget {
  SelectProjectScreen({Key key}) : super(key: key);

  final searchFieldController = TextEditingController();
  final searchController = Get.put(ProjectSearchController());

  final _projectsController = Get.put(
    ProjectsController(
      Get.put(ProjectsFilterController(), tag: 'ProjectsBottomSheet'),
      Get.put(PaginationController(), tag: 'ProjectsBottomSheet'),
    ),
    tag: 'ProjectsBottomSheet',
  );

  void onSelect(ProjectDetailed project) {
    Get.back(result: {
      'id': project.id,
      'title': project.title,
    });
    searchController.clearSearch();
    searchFieldController.clear();
  }

  final _platformController = Get.find<PlatformController>();

  @override
  Widget build(BuildContext context) {
    _projectsController.loadProjects();

    const searchIconKey = Key('srh');
    const clearIconKey = Key('clr');

    return Scaffold(
      backgroundColor:
          _platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor:
            _platformController.isMobile ? null : Get.theme.colors().surface,
        showBackButton: true,
        title: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutSine,
            switchOutCurve: Curves.fastOutSlowIn,
            child: searchController.switchToSearchView.isTrue
                ? TextField(
                    autofocus: true,
                    controller: searchFieldController,
                    decoration:
                        InputDecoration.collapsed(hintText: tr('enterQuery')),
                    style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onSurface,
                    ),
                    onSubmitted: searchController.newSearch,
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(tr('selectProject')),
                  ),
          ),
        ),
        actions: [
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutSine,
              switchOutCurve: Curves.fastOutSlowIn,
              child: searchController.switchToSearchView.isTrue
                  ? IconButton(
                      key: searchIconKey,
                      onPressed: () {
                        searchController.switchToSearchView.toggle();
                        searchFieldController.clear();
                        searchController.clearSearch();
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : IconButton(
                      key: clearIconKey,
                      onPressed: () =>
                          searchController.switchToSearchView.toggle(),
                      icon: const Icon(Icons.search),
                    ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (searchController.switchToSearchView.value == true &&
              searchController.searchResult.isNotEmpty) {
            return SmartRefresher(
              enablePullDown: false,
              enablePullUp: searchController.searchResult.length >= 25,
              controller: searchController.refreshController,
              onLoading: searchController.onLoading,
              child: ListView.separated(
                itemCount: searchController.searchResult.length,
                padding: const EdgeInsets.only(bottom: 16),
                separatorBuilder: (BuildContext context, int index) {
                  return const StyledDivider(
                    leftPadding: 16,
                    rightPadding: 16,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return _ProjectTile(
                    project: searchController.searchResult[index],
                    onPressed: () =>
                        onSelect(searchController.searchResult[index]),
                  );
                },
              ),
            );
          }
          if (searchController.switchToSearchView.value == true &&
              searchController.searchResult.isEmpty &&
              searchController.loaded.value == true &&
              searchFieldController.text.isNotEmpty) {
            return Column(children: [const NothingFound()]);
          }
          if (_projectsController.loaded.value == true) {
            return PaginationListView(
              paginationController: _projectsController.paginationController,
              child: ListView.separated(
                itemCount: _projectsController.paginationController.data.length,
                padding: const EdgeInsets.only(bottom: 16),
                separatorBuilder: (BuildContext context, int index) {
                  return const StyledDivider(
                    leftPadding: 16,
                    rightPadding: 16,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  var project =
                      _projectsController.paginationController.data[index];
                  return _ProjectTile(
                    project: project,
                    onPressed: () => onSelect(project),
                  );
                },
              ),
            );
          }
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({
    Key key,
    @required this.project,
    @required this.onPressed,
  }) : super(key: key);

  final ProjectDetailed project;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    project.title,
                    style: TextStyleHelper.projectTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    NameFormatter.formateName(project.responsible),
                    style: TextStyleHelper.projectResponsible,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
