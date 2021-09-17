import 'dart:async';

import 'package:get/get.dart';
import 'package:projects/data/api/portal_api.dart';
import 'package:projects/data/models/from_api/capabilities.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class PortalService {
  final PortalApi _api = locator<PortalApi>();

  Future<Capabilities> portalCapabilities(String portalName) async {
    var capabilities = await _api.getCapabilities(portalName);

    var success = capabilities.response != null;

    if (success) {
      return capabilities.response;
    } else {
      await Get.find<ErrorDialog>().show(capabilities.error.message);
      return null;
    }
  }
}
