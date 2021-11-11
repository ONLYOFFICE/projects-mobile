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

import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/error.dart';
import 'package:projects/internal/locator.dart';

class DownloadApi {
  Future<ApiDTO<Uint8List>> downloadImage(String avatarUrl) async {
    var url = '';
    if (avatarUrl.toLowerCase().contains('http')) {
      url = avatarUrl;
    } else {
      url = await locator.get<CoreApi>().getPortalURI() + avatarUrl;
    }

    var result = ApiDTO<Uint8List>();
    try {
      var response = await locator.get<CoreApi>().getRequest(url);

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
      url = await locator.get<CoreApi>().getPortalURI() + docUrl;
    }

    var result = ApiDTO<Uint8List>();
    try {
      var response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        result.response = response.bodyBytes;
      } else {}
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
