import 'dart:async';

import 'package:projects/data/api/portal_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/capabilities.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class PortalService {
  PortalApi _api = locator<PortalApi>();

  Future<Capabilities> portalCapabilities(String portalName) async {
    ApiDTO<Capabilities> capabilities = await _api.getCapabilities(portalName);

    var success = capabilities.response != null;

    if (success) {
      return capabilities.response;
    } else {
      ErrorDialog.show(capabilities.error);
      return null;
    }
  }
}
