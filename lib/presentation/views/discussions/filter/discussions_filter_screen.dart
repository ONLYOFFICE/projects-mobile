import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_filter_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/projects_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/tags_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/users_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/filters/confirm_filters_button.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_row.dart';
import 'package:projects/presentation/shared/widgets/filters/filter_element_widget.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

part 'filters/author.dart';
part 'filters/status.dart';
part 'filters/creation_date.dart';
part 'filters/project.dart';
part 'filters/other.dart';

class DiscussionsFilterScreen extends StatelessWidget {
  const DiscussionsFilterScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BaseFilterController filterController =
        Get.arguments['filterController'];

    return Scaffold(
      appBar: StyledAppBar(
        titleText: tr('filter'),
        showBackButton: true,
        actions: [
          TextButton(
              onPressed: () async => filterController.resetFilters(),
              child: Text(tr('reset'),
                  style: TextStyleHelper.button(
                      color: Theme.of(context).colors().systemBlue)))
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.5),
                  _Author(filterController: filterController),
                  _Status(filterController: filterController),
                  _CreatingDate(filterController: filterController),
                  _Project(filterController: filterController),
                  _Other(filterController: filterController),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          Obx(() {
            if (filterController.suitableResultCount.value != -1)
              return ConfirmFiltersButton(filterController: filterController);
            return const SizedBox();
          }),
        ],
      ),
    );
  }
}
