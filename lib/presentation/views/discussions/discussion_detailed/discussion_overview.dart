import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/status_button.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/info_tile.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

class DiscussionOverview extends StatelessWidget {
  final DiscussionItemController controller;
  const DiscussionOverview({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.loaded.value == false)
          return const ListLoadingSkeleton();
        else {
          var discussion = controller.discussion.value;
          return SmartRefresher(
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 72),
                  child: Text(tr('discussion').toUpperCase(),
                      style: TextStyleHelper.overline(
                          color: Get.theme
                              .colors()
                              .onBackground
                              .withOpacity(0.6))),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 72, right: 16),
                    child: Text(discussion.title,
                        style: TextStyleHelper.headline6(
                            color: Get.theme.colors().onSurface))),
                const SizedBox(height: 22),
                Obx(() => Align(
                      // otherwise it will take up the entire width
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 72, right: 16),
                        child: StatusButton(
                          text: controller.status.value == 1
                              ? tr('archived')
                              : tr('open'),
                          onPressed: () async =>
                              controller.tryChangingStatus(context),
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
                InfoTile(
                  caption: '${tr('description')}:',
                  icon: AppIcon(
                      icon: SvgIcons.description,
                      color: const Color(0xff707070)),
                  subtitleWidget: ReadMoreText(
                    discussion.text,
                    trimLines: 3,
                    colorClickableText: Colors.pink,
                    style: TextStyleHelper.body1,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: tr('showMore'),
                    trimExpandedText: tr('showLess'),
                    moreStyle:
                        TextStyleHelper.body2(color: Get.theme.colors().links),
                    lessStyle:
                        TextStyleHelper.body2(color: Get.theme.colors().links),
                  ),
                ),
                const SizedBox(height: 21),
                InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.project, color: const Color(0xff707070)),
                    caption: '${tr('project')}:',
                    subtitle: discussion.project.title,
                    subtitleStyle: TextStyleHelper.subtitle1(
                        color: Get.theme.colors().links)),
                if (discussion.created != null) const SizedBox(height: 20),
                if (discussion.created != null)
                  InfoTile(
                    caption: '${tr('creationDate')}:',
                    subtitle: formatedDate(discussion.created),
                  ),
                if (discussion.createdBy != null) const SizedBox(height: 20),
                if (discussion.createdBy != null)
                  InfoTile(
                    caption: '${tr('createdBy')}:',
                    subtitle: discussion.createdBy.displayName,
                  ),
                const SizedBox(height: 100),
              ],
            ),
          );
        }
      },
    );
  }
}
