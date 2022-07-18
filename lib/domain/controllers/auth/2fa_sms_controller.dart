// ignore_for_file: file_names

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
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/numbers_service.dart';
import 'package:projects/data/services/sms_code_service.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/authentication/2fa_sms/enter_sms_code_screen.dart';

class CountriesToShow {
  final CountryWithPhoneCode countrie;
  final bool showFirstLetter;

  const CountriesToShow({
    required this.countrie,
    this.showFirstLetter = false,
  });
}

class TFASmsController extends GetxController {
  final NumbersService _numberService = locator<NumbersService>();
  final SmsCodeService _service = locator<SmsCodeService>();

  RxBool loaded = false.obs;
  RxBool searching = false.obs;
  RxBool needToShowError = false.obs;

  late String _userName;
  late String _password;
  String? _phoneNoise;

  late String _locale;
  late List<CountryWithPhoneCode> _countries;
  RxList<CountriesToShow> countriesToShow = <CountriesToShow>[].obs;
  Rx<CountryWithPhoneCode?> deviceCountry = null.obs;

  final _phoneCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  TextEditingController get phoneCodeController => _phoneCodeController;

  TextEditingController get phoneNumberController => _phoneNumberController;

  String? get phoneNoise => _phoneNoise;

  String get number => '+${_phoneCodeController.text}${_phoneNumberController.text}'
      .replaceAll(RegExp(' |-|[()]'), '');

  @override
  // ignore: avoid_void_async
  void onInit() async {
    loaded = false.obs;
    await _numberService.init();
    _locale = _numberService.localeCode;
    _countries = _numberService.countries;
    _countries.sort((a, b) => a.countryName!.compareTo(b.countryName!));
    countriesToShow.value = _setupCountriesToShow(_countries);
    try {
      deviceCountry = _countries
          .firstWhereOrNull((element) => element.countryCode.toLowerCase() == _locale.toLowerCase())
          .obs;
      _phoneCodeController.text = deviceCountry.value?.phoneCode ?? '';
      if (deviceCountry.value?.phoneMaskFixedLineInternational != null) {
        _phoneNumberController = MaskedTextController(
            mask: deleteNumberPrefix(deviceCountry.value!.phoneMaskFixedLineInternational));
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loaded.value = true;
    super.onInit();
  }

  void initLoginAndPass(String login, String password) {
    _userName = login;
    _password = password;
  }

  void setPhoneNoise(String phoneNoise) => _phoneNoise = phoneNoise;

  void onSearchPressed() => searching.toggle();

  Future<void> onSendCodePressed() async {
    final result = await setPhone();
    if (result != null) await Get.to(() => const EnterSMSCodeScreen());
  }

  Future<void> onConfirmPressed(String code) async {
    needToShowError.value = false;
    final loginController = Get.find<LoginController>();
    final success = await loginController.sendCode(code.removeAllWhitespace,
        userName: _userName, password: _password);

    needToShowError.value = !success;
  }

  Future<void> resendSms() async {
    await _service.sendSms(
      userName: _userName,
      password: _password,
    );
  }

  void onSearch(String text) {
    final filteredCountries = _countries
        .where((element) => element.countryName!.toLowerCase().contains(text.toLowerCase()))
        .toList();
    countriesToShow.value = _setupCountriesToShow(filteredCountries);
  }

  void selectCountry(CountryWithPhoneCode country) {
    deviceCountry.value = country;
    countriesToShow.value = _setupCountriesToShow(_countries);
    _phoneCodeController.text = country.phoneCode;
    if (_phoneNumberController is MaskedTextController) {
      (_phoneNumberController as MaskedTextController)
          .updateMask(deleteNumberPrefix(deviceCountry.value!.phoneMaskFixedLineInternational));
    } else {
      _phoneNumberController = MaskedTextController(
          mask: deleteNumberPrefix(deviceCountry.value!.phoneMaskFixedLineInternational));
    }
    _phoneNumberController.clear();
    Get.back();
  }

  String deleteNumberPrefix(String number) {
    final mask = number.substring(number.indexOf(' '), number.length);
    return mask;
  }

  String get numberHint {
    if (deviceCountry.value != null) {
      return deleteNumberPrefix(deviceCountry.value?.phoneMaskFixedLineInternational ?? '')
          .replaceAll('0', '_');
    } else {
      return '';
    }
  }

  Future setPhone() async {
    final result = await _service.setPhone(
      mobilePhone: number,
      userName: _userName,
      password: _password,
    );

    if (result == null) return null;

    _phoneNoise = result.phoneNoise as String?;
    _phoneNumberController.clear();

    return result;
  }

  List<CountriesToShow> _setupCountriesToShow(List<CountryWithPhoneCode> countries) {
    final bufCountries = <CountriesToShow>[];
    for (var i = 0; i < countries.length; i++) {
      final currentCountrie = countries[i];
      if (i == 0) {
        bufCountries.add(CountriesToShow(countrie: currentCountrie, showFirstLetter: true));
      } else {
        final previousCountry = i > 0 ? countries.elementAt(i - 1) : null;
        if (previousCountry != null &&
            currentCountrie.countryName![0] != previousCountry.countryName![0]) {
          bufCountries.add(CountriesToShow(countrie: currentCountrie, showFirstLetter: true));
        } else {
          bufCountries.add(CountriesToShow(countrie: currentCountrie));
        }
      }
    }
    return bufCountries;
  }
}
