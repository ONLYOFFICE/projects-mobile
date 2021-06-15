import 'package:get/get.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';

class ImagesController {
  static final _portalInfo = Get.find<PortalInfoController>();

  static String getImagePath(String image) {
    if (image.toLowerCase().contains('http')) return image;
    return _portalInfo.portalUri + image;
  }

  static Map getHeaders() => _portalInfo.headers;
}
