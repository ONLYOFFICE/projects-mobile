import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/internal/extentions.dart';
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
        if (controller.loaded.isFalse)
          return const ListLoadingSkeleton();
        else {
          var discussion = controller.discussion.value;
          return SmartRefresher(
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            child: ListView(
              children: [
                InfoTile(
                  caption: 'Description:',
                  icon: AppIcon(
                      icon: SvgIcons.description,
                      color: const Color(0xff707070)),
                  subtitleWidget: ReadMoreText(
                    discussion.text,
                    trimLines: 3,
                    colorClickableText: Colors.pink,
                    style: TextStyleHelper.body1,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: TextStyleHelper.body2(
                        color: Theme.of(context).customColors().links),
                    lessStyle: TextStyleHelper.body2(color: Colors.pink),
                  ),
                ),
                const SizedBox(height: 21),
                InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.project, color: const Color(0xff707070)),
                  caption: 'Project:',
                  subtitle: discussion.project.title,
                  subtitleStyle: TextStyleHelper.subtitle1(
                      color: Theme.of(context).customColors().links),
                ),
                if (discussion.created != null) const SizedBox(height: 20),
                if (discussion.created != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.start_date,
                          color: const Color(0xff707070)),
                      caption: 'Creation date:',
                      subtitle: formatedDate(discussion.created)),
                if (discussion.createdBy != null) const SizedBox(height: 20),
                if (discussion.createdBy != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.start_date,
                          color: const Color(0xff707070)),
                      caption: 'Created by:',
                      subtitle: discussion.createdBy.displayName),
              ],
            ),
          );
        }
      },
    );
  }
}
