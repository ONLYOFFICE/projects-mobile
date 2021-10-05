import 'dart:typed_data';
import 'package:http/http.dart' as http;

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

      if (response is http.Response) {
        result.response = response.bodyBytes;
      } else {}
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<Uint8List>> downloadDocument(String docUrl) async {
    var url = '';
    if (docUrl.toLowerCase().contains('http')) {
      url = docUrl;
    } else {
      url = await coreApi.getPortalURI() + docUrl;
    }

    var result = ApiDTO<Uint8List>();
    try {
      var response = await coreApi.getRequest(url);

      if (response is http.Response) {
        result.response = response.bodyBytes;
      } else {}
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
