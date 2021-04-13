import 'dart:typed_data';

import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/error.dart';
import 'package:projects/internal/locator.dart';

class DownloadApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<Uint8List>> downloadImage(String avatarUrl) async {
    var url = '';
    if (avatarUrl.toLowerCase().contains('http')) {
      url = avatarUrl;
    } else {
      url = await coreApi.getPortalURI() + avatarUrl;
    }

    var result = ApiDTO<Uint8List>();
    try {
      var response = await coreApi.getRequest(url);

      if (response.statusCode == 200) {
        result.response = response.bodyBytes;
      } else {}
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;
  }
}
