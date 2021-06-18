import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class CustomTab extends StatelessWidget {
  final String title;
  final int count;
  final bool currentTab;
  const CustomTab({
    Key key,
    this.title,
    this.count,
    this.currentTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Text(title),
          if (count != null && count >= 0) const SizedBox(width: 8),
          if (count != null && count >= 0)
            Container(
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              constraints: const BoxConstraints(minWidth: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: currentTab
                      ? Theme.of(context).customColors().primary
                      : Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.3)),
              child: Center(
                  child: Text(count.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).customColors().surface,
                          letterSpacing: 0.1))),
            ),
        ],
      ),
    );
  }
}
