import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_tag.dart';

class TagItemDTO {
  TagItemDTO({
    this.isSelected,
    this.tag,
  });
  RxBool isSelected;
  ProjectTag tag;
}
