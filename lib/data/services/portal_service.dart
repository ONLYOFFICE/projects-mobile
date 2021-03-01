import 'dart:async';

import 'package:only_office_mobile/data/api/portal_api.dart';
import 'package:only_office_mobile/data/models/apiDTO.dart';
import 'package:only_office_mobile/data/models/capabilities.dart';
import 'package:only_office_mobile/internal/locator.dart';

class PortalService {
  PortalApi _api = locator<PortalApi>();

  Future<ApiDTO<Capabilities>> portalCapabilities(String portalName) async {
    ApiDTO<Capabilities> response = await _api.getCapabilities(portalName);

    // var capabilities = response.response != null;

    // if (tokenReceived) {
    //   userController.add(response.response);
    // } else {
    //   userController.addError(response.error);
    // }
    return response;
  }
}
