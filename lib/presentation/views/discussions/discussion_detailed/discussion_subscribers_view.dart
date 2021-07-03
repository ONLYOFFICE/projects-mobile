import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiscussionSubscribersView extends StatelessWidget {
  final DiscussionItemController controller;
  const DiscussionSubscribersView({
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
          return Stack(
            children: [
              SmartRefresher(
                controller: controller.refreshController,
                onRefresh: controller.onRefresh,
                child: ListView.separated(
                  itemCount: discussion.subscribers.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 24);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CustomNetworkImage(
                              image: discussion.subscribers[index].avatar ??
                                  discussion.subscribers[index].avatarMedium ??
                                  discussion.subscribers[index].avatarSmall,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                discussion.subscribers[index].displayName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyleHelper.subtitle1(
                                    color: Theme.of(context)
                                        .customColors()
                                        .onSurface),
                              ),
                              if (discussion.subscribers[index]?.title != null)
                                Text(discussion.subscribers[index]?.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyleHelper.caption(
                                        color: Theme.of(context)
                                            .customColors()
                                            .onSurface
                                            .withOpacity(0.6))),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 24),
                  child: StyledFloatingActionButton(
                    onPressed: () {},
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }
}
