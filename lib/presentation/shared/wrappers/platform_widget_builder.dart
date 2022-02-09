import 'package:flutter/widgets.dart';

import 'package:projects/presentation/shared/wrappers/platform.dart';
import 'package:projects/presentation/shared/wrappers/platform_widget.dart';

/// Provides a builder for either the Material or Cupertino platforms
/// which take a child for common use
///
/// ```dart
/// PlatformWidgetBuilder(;
///   cupertino: (context, child, target) => GestureDetector(child: child, onTap: _handleTap),
///   material: (context, child, target) => InkWell(child: child, onTap: _handleTap),
///   child: Container(child: Text('Common text')),
/// );
///
/// ```
class PlatformWidgetBuilder extends StatelessWidget {
  final Widget? child;
  final Widget? Function(BuildContext, Widget?, PlatformTarget)? cupertino;
  final Widget? Function(BuildContext, Widget?, PlatformTarget)? material;

  PlatformWidgetBuilder({
    Key? key,
    this.cupertino,
    this.material,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      cupertino: (context, target) => cupertino?.call(context, child, target),
      material: (context, target) => material?.call(context, child, target),
    );
  }
}
