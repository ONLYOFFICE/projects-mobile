import 'package:flutter/material.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';

class ProjectDiscussionsScreen extends StatelessWidget {
  final ProjectDetailed projectDetailed;
  const ProjectDiscussionsScreen({
    Key key,
    @required this.projectDetailed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _coreApi = locator<CoreApi>();
    // var _comments = controller.task.value.comments;
    return FutureBuilder(
      future: Future.wait([_coreApi.getPortalURI(), _coreApi.getHeaders()]),
      builder: (context, snapshot) {
        // if (snapshot.hasData) {
        // return Obx(
        // () {
        //   if (controller.loaded.isTrue) {
        //     return SmartRefresher(
        //       controller: controller.refreshController,
        //       onRefresh: () async => await controller.reloadTask(),
        //       child: ListView.separated(
        //         itemCount: _comments.length,
        //         padding: const EdgeInsets.symmetric(vertical: 32),
        //         separatorBuilder: (BuildContext context, int index) {
        //           return const SizedBox(height: 21);
        //         },
        //         itemBuilder: (BuildContext context, int index) {
        //           return Column(
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.symmetric(horizontal: 12),
        //                 child: Comment(
        //                     comment: _comments[index],
        //                     portalUri: snapshot.data[0],
        //                     headers: snapshot.data[1]),
        //               ),
        //               ListView.separated(
        //                 itemCount: _comments[index].commentList.length,
        //                 shrinkWrap: true,
        //                 primary: false,
        //                 padding: const EdgeInsets.symmetric(vertical: 29),
        //                 separatorBuilder: (context, index) {
        //                   return const SizedBox(height: 30);
        //                 },
        //                 itemBuilder: (context, i) {
        //                   return Padding(
        //                     padding:
        //                         const EdgeInsets.only(left: 20, right: 12),
        //                     child: Comment(
        //                         comment: _comments[index].commentList[i],
        //                         portalUri: snapshot.data[0],
        //                         headers: snapshot.data[1]),
        //                   );
        //                 },
        //               ),
        //             ],
        //           );
        //         },
        //       ),
        //     );
        //   } else {
        //         return const ListLoadingSkeleton();
        //       }
        //     },
        //   );
        // } else {
        return const ListLoadingSkeleton();
        // }
      },
    );
  }
}