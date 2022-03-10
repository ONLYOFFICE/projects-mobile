import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/wrappers/platform.dart';

const double _kMenuDividerHeight = 16;
const double _iosMenuDividerHeight = 8;

final Color _kBackgroundColorPressed =
    Get.isDarkMode ? const Color.fromRGBO(54, 54, 54, 1) : const Color.fromRGBO(216, 216, 216, 1);

class PlatformPopupMenuDivider extends PopupMenuEntry {
  const PlatformPopupMenuDivider({Key? key, this.height = _kMenuDividerHeight}) : super(key: key);

  @override
  final double height;

  @override
  bool represents(void value) => false;

  @override
  State<PlatformPopupMenuDivider> createState() => _PopupMenuDividerState();
}

class _PopupMenuDividerState extends State<PlatformPopupMenuDivider> {
  Widget createMaterialWidget(BuildContext context) => Divider(
        height: widget.height,
        thickness: widget.height,
      );
  Widget createCupertinoWidget(BuildContext context) => Divider(
        height: _iosMenuDividerHeight,
        thickness: _iosMenuDividerHeight,
        color: _kBackgroundColorPressed,
      );

  @override
  Widget build(BuildContext context) {
    if (isMaterial(context)) {
      return createMaterialWidget(context);
    } else if (isCupertino(context)) {
      return createCupertinoWidget(context);
    }

    return throw UnsupportedError('This platform is not supported');
  }
}
