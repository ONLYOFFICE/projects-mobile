import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';

class DocumentsSortOption extends StatelessWidget {
  const DocumentsSortOption({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        SortTile(
          sortParameter: 'dateandtime',
          sortController: controller.sortController,
        ),
        SortTile(
          sortParameter: 'create_on',
          sortController: controller.sortController,
        ),
        SortTile(
          sortParameter: 'AZ',
          sortController: controller.sortController,
        ),
        SortTile(
          sortParameter: 'type',
          sortController: controller.sortController,
        ),
        SortTile(
          sortParameter: 'size',
          sortController: controller.sortController,
        ),
        SortTile(
          sortParameter: 'author',
          sortController: controller.sortController,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
