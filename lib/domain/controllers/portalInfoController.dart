import 'package:get/get.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/internal/locator.dart';

class PortalInfoController extends GetxController {
  final _coreApi = locator<CoreApi>();

  String _portalName;
  String _portalUri;
  Map _headers;

  String get portalUri => _portalUri;
  String get portalName => _portalName;
  Map get headers => _headers;

  @override
  void onInit() async {
    _portalUri ??= await _coreApi.getPortalURI();
    _headers ??= await _coreApi.getHeaders();
    _portalName ??= _portalUri.replaceFirst('https://', '');

    super.onInit();
  }

  void logout() {
    _portalName = null;
    _portalUri = null;
    _headers = null;
  }

  Future<void> setup() async {
    _portalUri ??= await _coreApi.getPortalURI();
    _headers ??= await _coreApi.getHeaders();
    _portalName ??= _portalUri.replaceFirst('https://', '');
  }
}
