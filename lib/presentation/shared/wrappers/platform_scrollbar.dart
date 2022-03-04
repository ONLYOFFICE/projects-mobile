import 'package:flutter/cupertino.dart' show CupertinoScrollbar;
import 'package:flutter/material.dart' show Scrollbar;
import 'package:flutter/widgets.dart';

import 'package:projects/presentation/shared/wrappers/widget_base.dart';

class PlatformScrollbar extends PlatformWidgetBase<CupertinoScrollbar, Scrollbar> {
  final Widget child;

  PlatformScrollbar({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Scrollbar createMaterialWidget(BuildContext context) {
    return Scrollbar(
      child: child,
    );
  }

  @override
  CupertinoScrollbar createCupertinoWidget(BuildContext context) {
    return CupertinoScrollbar(
      child: child,
    );
  }
}
