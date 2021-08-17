import 'package:get/get.dart';

import 'package:projects/data/models/tag_itemDTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/internal/locator.dart';

class TagsController extends GetxController {
  final _api = locator<ProjectService>();
  var usersList = [].obs;
  var loaded = true.obs;

  var isSearchResult = false.obs;

  RxList<TagItemDTO> tags = <TagItemDTO>[].obs;

  RxList<String> projectDetailedTags = <String>[].obs;

  var _projController;

  void onLoading() async {}

  Future<void> setup(projController) async {
    _projController = projController;
    loaded.value = false;
    tags.clear();
    projectDetailedTags.clear();
    var allTags = await _api.getProjectTags();

    if (projController?.tags != null) {
      for (var value in projController?.tags) {
        projectDetailedTags.add(value);
      }
    }

    if (allTags != null) {
      for (var tag in allTags) {
        var isSelected = projectDetailedTags?.contains(tag.title)?.obs;

        tags.add(TagItemDTO(isSelected: isSelected, tag: tag));
      }
    }

    loaded.value = true;
  }

  Future<void> confirm() async {
    _projController.tags.clear();
    for (var tag in tags) {
      if (tag.isSelected.value) {
        _projController.tags.add(tag.tag.title);
      }
    }
    _projController.tagsText.value = _projController.tags.join(', ');
    Get.back();
  }

  Future changeTagSelection(TagItemDTO tag) async {
    tag.isSelected.value = !tag.isSelected.value;

    _projController.tags.clear();
    for (var tag in tags) {
      if (tag.isSelected.value) {
        _projController.tags.add(tag.tag.title);
      }
    }

    _projController.tagsText.value = _projController.tags.join(', ');
  }

  Future<void> createTag(String value) async {
    var res = await _api.createTag(name: value);
    if (res != null) await setup(_projController);
  }
}
