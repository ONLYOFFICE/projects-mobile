import 'package:get/get.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';

class ImagesController {
  static final _portalInfo = Get.find<PortalInfoController>();

  static String getImagePath(String image) {
    if (image.toLowerCase().contains('http')) return image;

    if (_portalInfo.portalUri == null) _portalInfo.onInit();
    return _portalInfo.portalUri + image;
  }

  static Future<Map> getHeaders() async {
    if (_portalInfo.headers == null || _portalInfo.headers.isEmpty) {
      _portalInfo.onInit();
    }

    return _portalInfo.headers;
  }
}
