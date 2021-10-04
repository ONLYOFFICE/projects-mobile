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

import 'package:projects/data/services/local_authentication_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/internal/locator.dart';

class PasscodeService {
  final _storage = locator<SecureStorage>();
  final _biometricService = locator<LocalAuthenticationService>();

  Future<String> get getPasscode async => await _storage.getString('passcode');

  Future<void> setPasscode(String code) async {
    await deletePasscode();
    await _storage.putString('passcode', code);
  }

  Future<void> deletePasscode() async => await _storage.delete('passcode');

  Future<void> setFingerprintStatus(bool isEnable) async {
    var status = isEnable ? 'true' : 'false';
    await _storage.delete('isFingerprintEnable');
    await _storage.putString('isFingerprintEnable', status);
  }

  Future<bool> get isFingerprintEnable async {
    var isFingerprintEnable =
        await _storage.getString('isFingerprintEnable') ?? false;

    return isFingerprintEnable == 'true' ? true : false;
  }

  Future<bool> get isFingerprintAvailable async {
    var isFingerprintAvailable =
        await _biometricService.isFingerprintAvailable ?? false;

    return isFingerprintAvailable;
  }

  Future<bool> get isPasscodeEnable async {
    var isPasscodeEnable = await _storage.getString('passcode') ?? false;
    if (isPasscodeEnable != false) return true;
    return false;
  }
}
