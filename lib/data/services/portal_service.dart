import 'dart:async';

import 'package:only_office_mobile/data/api/portal_api.dart';
import 'package:only_office_mobile/data/models/apiDTO.dart';
import 'package:only_office_mobile/data/models/capabilities.dart';
import 'package:only_office_mobile/domain/dialogs.dart';
import 'package:only_office_mobile/internal/locator.dart';

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
