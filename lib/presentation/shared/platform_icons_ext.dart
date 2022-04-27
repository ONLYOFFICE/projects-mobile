import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

extension CustomPlatformIcons on PlatformIcons {
  /// Render either a Material or Cupertino icon based on the platform
  IconData get checkMark => isMaterial(context) ? Icons.check_rounded : CupertinoIcons.checkmark;
  IconData get checkMarkAlt =>
      isMaterial(context) ? Icons.check_rounded : CupertinoIcons.checkmark_alt;

  // checkboxes
  IconData get unchecked =>
      isMaterial(context) ? Icons.check_box_outline_blank_rounded : CupertinoIcons.circle;
  IconData get checked =>
      isMaterial(context) ? Icons.check_box_rounded : CupertinoIcons.check_mark_circled_solid;

  IconData get clear => isMaterial(context) ? Icons.clear : CupertinoIcons.clear;

  IconData get ellipsis => isMaterial(context) ? Icons.more_vert : CupertinoIcons.ellipsis;

  IconData get downChevron =>
      isMaterial(context) ? Icons.keyboard_arrow_down_rounded : CupertinoIcons.chevron_down;

  IconData get plus => isMaterial(context) ? Icons.add_rounded : CupertinoIcons.plus;
}
