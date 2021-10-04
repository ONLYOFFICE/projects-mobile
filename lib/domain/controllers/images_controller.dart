import 'package:get/get.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';

class ImagesController {
  final _portalInfo = Get.find<PortalInfoController>();

  String getImagePath(String image) {
    _portalInfo.setup();
    if (image.toLowerCase().contains('http')) return image;

    if (_portalInfo.portalUri == null) _portalInfo.setup();
    return _portalInfo.portalUri + image;
  }

  Future<Map> getHeaders() async {
    await _portalInfo.setup();
    if (_portalInfo.headers == null || _portalInfo.headers.isEmpty) {
      _portalInfo.onInit();
    }

    return _portalInfo.headers;
  }
}
