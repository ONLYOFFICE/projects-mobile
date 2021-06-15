import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';

class DiscussionTile extends StatelessWidget {
  final Discussion discussion;
  const DiscussionTile({
    Key key,
    @required this.discussion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(discussion.createdBy.avatarMedium);
    print(discussion.createdBy.avatarSmall);
    print(discussion.createdBy.avatar);
    return InkWell(
      onTap: () => Get.toNamed('DiscussionDetailed'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _Image(
              image: discussion.createdBy.avatar ??
                  discussion.createdBy.avatarMedium ??
                  discussion.createdBy.avatarSmall,
            ),
            const SizedBox(width: 16),
            _DiscussionInfo(discussion: discussion),
            const SizedBox(width: 11.33),
            _CommentsCount(commentsCount: discussion.commentsCount),
          ],
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String image;
  const _Image({
    Key key,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: CustomNetworkImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _DiscussionInfo extends StatelessWidget {
  final Discussion discussion;
  const _DiscussionInfo({
    Key key,
    @required this.discussion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            discussion.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyleHelper.projectTitle,
          ),
          RichText(
            text: TextSpan(
              style: TextStyleHelper.caption(
                  color: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.6)),
              children: [
                if (discussion.status == 1)
                  TextSpan(
                      text: 'Archived • ',
                      style: TextStyleHelper.status(
                          color: Theme.of(context).customColors().onSurface)),
                TextSpan(text: formatedDate(discussion.created)),
                const TextSpan(text: ' • '),
                TextSpan(text: discussion.createdBy.displayName)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsCount extends StatelessWidget {
  final int commentsCount;
  const _CommentsCount({
    Key key,
    @required this.commentsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppIcon(
            icon: SvgIcons.comments,
            color:
                Theme.of(context).customColors().onBackground.withOpacity(0.6)),
        const SizedBox(width: 5.33),
        Text(commentsCount.toString(),
            style: TextStyleHelper.body2(
                color: Theme.of(context)
                    .customColors()
                    .onBackground
                    .withOpacity(0.6))),
      ],
    );
  }
}