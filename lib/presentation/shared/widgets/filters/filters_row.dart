import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class FiltersRow extends StatelessWidget {
  final String title;
  final List<Widget> options;
  const FiltersRow({Key key, this.title, this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 20),
          child: Text(
            title,
            style: TextStyleHelper.h6(color: Get.theme.colors().onSurface),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            runSpacing: 16,
            spacing: 16,
            children: options,
          ),
        ),
        const SizedBox(height: 35),
      ],
    );
  }
}
