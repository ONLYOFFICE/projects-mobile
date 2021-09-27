import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/default_avatar.dart';

class UserSelectionTile extends StatelessWidget {
  final String image;
  final String displayName;
  final String caption;
  final bool value;
  final Function(bool value) onChanged;
  const UserSelectionTile({
    Key key,
    this.image,
    this.displayName,
    this.caption,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      activeColor: Get.theme.colors().primary,
      contentPadding: const EdgeInsets.only(left: 16, right: 9),
      title: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CustomNetworkImage(
                image: image,
                defaultImage: const DefaultAvatar(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 2,
                  style: TextStyleHelper.subtitle1(
                    color: Get.theme.colors().onSurface,
                  ),
                ),
                if (caption != null)
                  Text(
                    caption,
                    maxLines: 2,
                    style: TextStyleHelper.caption(
                        color: Get.theme.colors().onSurface.withOpacity(0.6)),
                  ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
