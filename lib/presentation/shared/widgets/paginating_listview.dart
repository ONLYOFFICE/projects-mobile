import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PaginationListView<T> extends StatelessWidget {
  const PaginationListView({
    Key key,
    @required this.paginationController,
    @required this.child,
  }) : super(key: key);

  final paginationController;
  final child;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: paginationController.pullDownEnabled,
        enablePullUp: paginationController.pullUpEnabled,
        controller: paginationController.refreshController,
        onRefresh: paginationController.onRefresh,
        onLoading: paginationController.onLoading,
        child: child);
  }
}
