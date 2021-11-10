/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */
import 'package:synchronized/synchronized.dart';
import 'package:get/get.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/internal/locator.dart';

class PortalInfoController extends GetxController {
  final _coreApi = locator<CoreApi>();
  var lock = Lock();
  String _portalName;
  String _portalUri;
  Map _headers;

  String get portalUri => _portalUri;
  String get portalName => _portalName;
  Map get headers => _headers;

  @override
  void onInit() async {
    await setup();

    super.onInit();
  }

  void logout() {
    _portalName = null;
    _portalUri = null;
    _headers = null;
  }

  Future<bool> setup() async {
    var ret = await lock.synchronized(() async {
      _portalUri ??= await _coreApi.getPortalURI();
      _headers ??= await _coreApi.getHeaders();
      if (_portalUri == null) return Future.value(false);
      _portalName ??= _portalUri.replaceFirst('https://', '');
      return Future.value(true);
    });
    return Future.value(ret);
  }
}
