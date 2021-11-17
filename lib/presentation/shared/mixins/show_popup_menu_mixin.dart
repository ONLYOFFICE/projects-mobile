import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin ShowPopupMenuMixin on Widget {
  Future<void> showPopupMenu(
      {BuildContext context, List<dynamic> options, Offset offset}) async {
    var items = options.map((e) => PopupMenuItem(child: e)).toList();

// calculate the menu position, offset dy: 50
    // final offset = const Offset(0, 50);
    final button = context.findRenderObject() as RenderBox;
    final overlay = Get.overlayContext.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          offset,
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    await showMenu(context: context, position: position, items: items);
  }
}
