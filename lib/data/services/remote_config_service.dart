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

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfigService._privateConstructor();

  static RemoteConfig remoteConfigPackingProperty = null;

  static RemoteConfig get _remoteConfig {
    return remoteConfigPackingProperty ??= RemoteConfig.instance;
  }

  /// Public
  static const _RemoteConfigKeys Keys = _RemoteConfigKeys();

  /// Initialize remote config
  static Future<RemoteConfig> initialize() async {
    // Setup defaults
    await _remoteConfig.setDefaults(<String, dynamic>{
      RemoteConfigService.Keys
          .linkTermsOfService: 'https://help.onlyoffice.com/products/files/doceditor.aspx?fileid=5048471&doc=bXJ6UmJacDVnVDMxV01oMHhrUlpwaGFBcXJUUUE3VHRuTGZrRUF5a1NKVT0_IjUwNDg0NzEi0',
      RemoteConfigService.Keys
          .linkPrivacyPolicy: 'https://help.onlyoffice.com/products/files/doceditor.aspx?fileid=5048502&doc=SXhWMEVzSEYxNlVVaXJJeUVtS0kyYk14YWdXTEFUQmRWL250NllHNUFGbz0_IjUwNDg1MDIi0'
    });

    // Fetch remote values
    await _remoteConfig.fetchAndActivate();

    return _remoteConfig;
  }

  /// Gets the value for a given key as a bool.
  static bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  /// Gets the value for a given key as an int.
  static int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  /// Gets the value for a given key as a double.
  static double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }

  /// Gets the value for a given key as a String.
  static String getString(String key) {
    return _remoteConfig.getString(key);
  }

  /// Gets the [RemoteConfigValue] for a given key.
  static RemoteConfigValue getValue(String key) {
    return _remoteConfig.getValue(key);
  }

}

class _RemoteConfigKeys {
  const _RemoteConfigKeys();

  final linkTermsOfService = 'link_terms_of_service';
  final linkPrivacyPolicy = 'link_privacy_policy';
}