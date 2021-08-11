import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModalScreenView extends StatelessWidget {
  final Widget contentView;

  const ModalScreenView({
    Key key,
    @required this.contentView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 480,
                height: 608,
                child: contentView,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
