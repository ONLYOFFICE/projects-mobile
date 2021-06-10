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

import 'package:flutter/cupertino.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/numbers_service.dart';
import 'package:projects/data/services/sms_code_service.dart';
import 'package:projects/domain/controllers/login_controller.dart';
import 'package:projects/internal/locator.dart';

class TFASmsController extends GetxController {
  final _numberService = locator<NumbersService>();
  final _service = locator<SmsCodeService>();

  var loaded = false.obs;
  var searching = false.obs;
  var codeError = false.obs;

  var _userName;
  var _password;
  var _phoneNoise;

  String _locale;
  List<CountryWithPhoneCode> _countries;
  RxList<CountryWithPhoneCode> countriesToShow;
  Rx<CountryWithPhoneCode> deviceCountry = null.obs;

  final _phoneCodeController = TextEditingController();
  MaskedTextController _phoneNumberController;
  TextEditingController get phoneCodeController => _phoneCodeController;
  MaskedTextController get phoneNumberController => _phoneNumberController;
  String get phoneNoise => _phoneNoise;

  String get number {
    var number = '+${_phoneCodeController.text}${_phoneNumberController.text}';
    number = number.replaceAll(RegExp(r' |-|[()]'), '');
    return number;
  }

  @override
  void onInit() async {
    loaded = false.obs;
    await _numberService.init();
    _locale = _numberService.localeCode;
    _countries = _numberService.countries;
    _countries.sort((a, b) => a.countryName[0].compareTo(b.countryName[0]));
    countriesToShow = _countries.obs;

    try {
      deviceCountry = _countries
          .firstWhere((element) => element.countryCode
              .toLowerCase()
              .contains(_locale?.toLowerCase()))
          .obs;
      _phoneCodeController.text = deviceCountry?.value?.phoneCode;
      _phoneNumberController = MaskedTextController(
          mask: deleteNumberPrefix(
              deviceCountry?.value?.phoneMaskFixedLineNational));
      // ignore: empty_catches
    } catch (e) {}

    loaded.value = true;
    super.onInit();
  }

  void initLoginAndPass(String login, String password) {
    _userName = login;
    _password = password;
  }

  void setPhoneNoise(phoneNoise) => _phoneNoise = phoneNoise;

  void onSearchPressed() => searching.toggle();
  void onSendCodePressed() async {
    var result = await setPhone();
    if (result != null) await Get.toNamed('EnterSMSCodeScreen');
  }

  void onConfirmPressed(String code) async {
    codeError.value = false;
    var loginController = Get.find<LoginController>();
    var resp = await loginController.sendCode(code.removeAllWhitespace,
        userName: _userName, password: _password);

    if (resp == false) codeError.value = true;
  }

  void resendSms() async {
    await _service.sendSms(
      userName: _userName,
      password: _password,
    );
  }

  void onSearch(String text) {
    countriesToShow.value = _countries
        .where((element) =>
            element.countryName.toLowerCase().contains(text.toLowerCase()))
        .toList()
        .obs;
  }

  void selectCountry(CountryWithPhoneCode country) {
    deviceCountry.value = country;
    countriesToShow.value = _countries;
    _phoneCodeController.text = country.phoneCode;
    _phoneNumberController.updateMask(
        deleteNumberPrefix(deviceCountry.value.phoneMaskFixedLineNational));
    _phoneNumberController.clear();
    Get.back();
  }

  String deleteNumberPrefix(String number) {
    return number.substring(number.indexOf(' '), number.length);
  }

  String get numberHint {
    return deleteNumberPrefix(
            deviceCountry.value.phoneMaskFixedLineInternational)
        .replaceAll('0', '_');
  }

  Future setPhone() async {
    var result = await _service.setPhone(
      mobilePhone: number,
      userName: _userName,
      password: _password,
    );

    _phoneNoise = result.phoneNoise;

    return result;
  }
}
