import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';

class ListLoadingSkeleton extends StatelessWidget {
  const ListLoadingSkeleton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _decoration = BoxDecoration(
        color: Theme.of(context).customColors().bgDescription,
        borderRadius: BorderRadius.circular(2));

    return Container(
      child: Column(
        children: [
          LinearProgressIndicator(
            minHeight: 4,
            backgroundColor: Theme.of(context).customColors().primary,
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xffb5c4d2)),
          ),
          Shimmer.fromColors(
            baseColor: Theme.of(context).customColors().bgDescription,
            highlightColor: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 22),
                for (var i = 0; i < 4; i++)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            bottom: 32, left: 16, right: 16),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).customColors().bgDescription),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 12, decoration: _decoration),
                            Container(
                                height: 12,
                                margin: const EdgeInsets.only(top: 6),
                                width: Get.width / 3,
                                decoration: _decoration)
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          width: 41,
                          height: 12,
                          decoration: _decoration)
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
