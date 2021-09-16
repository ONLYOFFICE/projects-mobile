import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class StyledFloatingActionButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final Color backgroundColor;

  const StyledFloatingActionButton({
    Key key,
    this.backgroundColor, //= Get.theme.customColors().lightSecondary,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MessagesHandler.isDisplayed,
      builder: (context, value, _) {
        // ignore: omit_local_variable_types
        double padding = value ? 60.0 : 0.0;
        return AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(bottom: padding),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 1)),
                const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 4)),
              ],
            ),
            child: FloatingActionButton(
              backgroundColor: Get.theme.colors().lightSecondary,
              onPressed: onPressed,
              elevation: 0,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
