import 'dart:convert';

import 'package:only_office_mobile/data/models/apiDTO.dart';
import 'package:only_office_mobile/data/models/capabilities.dart';
import 'package:only_office_mobile/internal/locator.dart';
import 'package:only_office_mobile/data/api/core_api.dart';
import 'package:only_office_mobile/data/models/error.dart';

class PortalApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<Capabilities>> getCapabilities(String portalName) async {
    var url = coreApi.capabilitiesUrl(portalName);

    var result = new ApiDTO<Capabilities>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = Capabilities.fromJson(responseJson);
      } else {
        result.error = PortalError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new PortalError(message: 'Чтото пошло не так');
    }

    return result;
  }
}
