import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    Key key,
    @required this.controller,
    this.searchFunction,
    this.clearFunction,
  }) : super(key: key);

  final controller;
  final Function(String value) searchFunction;
  final VoidCallback clearFunction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              controller: controller.searchInputController,
              decoration: InputDecoration.collapsed(hintText: tr('enterQuery')),
              onSubmitted: searchFunction ?? controller.newSearch,
            ),
          ),
          InkResponse(
            onTap: clearFunction ?? controller.clearSearch,
            child: const Icon(Icons.close, color: Colors.blue),
          )
        ],
      ),
    );
  }
}
