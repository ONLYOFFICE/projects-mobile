import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/capabilities.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class PortalApi {
  var coreApi = locator<CoreApi>();
  var secureStorage = locator<SecureStorage>();

  Future<ApiDTO<Capabilities>> getCapabilities(String portalName) async {
    var url = coreApi.capabilitiesUrl(portalName);

    var result = ApiDTO<Capabilities>();
    try {
      var response = await coreApi.getRequest(url);

      if (response is http.Response) {
        final Map responseJson = json.decode(response.body);
        result.response = Capabilities.fromJson(responseJson['response']);
        await coreApi.savePortalName();
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      var error;
      if (e is SocketException) error = e?.osError?.message;
      result.error = CustomError(message: error ?? e.toString());
    }

    return result;
  }
}
