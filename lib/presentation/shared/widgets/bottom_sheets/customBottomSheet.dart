import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

// TODO удали как увидишь. Я добавил эту функцию для bs, в ней определен
// максимальный размер, чтобы не закрывался статус бар. Давай использовать ее.
void showCustomBottomSheet({
  @required context,
  @required double headerHeight,
  // ignore: use_function_type_syntax_for_parameters
  @required Widget headerBuilder(context, bottomSheetOffset),
  // ignore: use_function_type_syntax_for_parameters
  @required SliverChildDelegate builder(context, bottomSheetOffset),
  double initHeight,
  double maxHeight,
  BoxDecoration decoration,
}) async {
  var heightWithoutStatusBar = _getMaxHeight(context);

  await showStickyFlexibleBottomSheet(
    context: context,
    headerBuilder: headerBuilder,
    builder: builder,
    headerHeight: headerHeight,
    decoration: decoration,
    initHeight: initHeight ?? heightWithoutStatusBar - 0.1,
    maxHeight: maxHeight ?? heightWithoutStatusBar,
  );
}

double _getMaxHeight(context) {
  var screenHeight = MediaQuery.of(context).size.height;
  var statusBarHeight = MediaQuery.of(context).padding.top == 0
      ? 32
      : MediaQuery.of(context).padding.top;

  return (screenHeight - statusBarHeight - 8) / screenHeight;
}
