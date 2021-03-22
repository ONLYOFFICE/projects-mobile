import 'dart:convert';

import 'package:only_office_mobile/data/models/apiDTO.dart';
import 'package:only_office_mobile/data/models/from_api/capabilities.dart';
import 'package:only_office_mobile/data/services/storage.dart';
import 'package:only_office_mobile/internal/locator.dart';
import 'package:only_office_mobile/data/api/core_api.dart';
import 'package:only_office_mobile/data/models/from_api/error.dart';

class PortalApi {
  var coreApi = locator<CoreApi>();
  var secureStorage = locator<Storage>();

  Future<ApiDTO<Capabilities>> getCapabilities(String portalName) async {
    var url = await coreApi.capabilitiesUrl(portalName);

    var result = new ApiDTO<Capabilities>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = Capabilities.fromJson(responseJson['response']);
        secureStorage.putString('portalName', portalName);
      } else {
        result.error = CustomError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new CustomError(message: 'Ошибка');
    }

    return result;
  }
}
