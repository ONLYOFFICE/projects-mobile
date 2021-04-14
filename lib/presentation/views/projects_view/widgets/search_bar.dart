import 'package:flutter/material.dart';

import 'package:projects/domain/controllers/projects/users_data_source.dart';
import 'package:projects/presentation/shared/custom_theme.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final UsersDataSource controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 10),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).customColors().bgDescription,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                textInputAction: TextInputAction.search,
                controller: controller.searchInputController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Search for users...',
                ),
                onSubmitted: (value) {
                  controller.searchUsers(value);
                },
              ),
            ),
            InkWell(
              onTap: () {
                controller.clearSearch();
              },
              child: Icon(
                Icons.close,
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
