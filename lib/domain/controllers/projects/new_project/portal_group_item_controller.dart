import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_group.dart';

class PortalGroupItemController extends GetxController {
  var groupTitle = ''.obs;

  PortalGroupItemController({
    this.portalGroup,
  }) {}
  final PortalGroup portalGroup;
  var isSelected = false.obs;

  String get displayName => portalGroup.name;
}
