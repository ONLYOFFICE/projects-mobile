import 'package:flutter/cupertino.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/numbers_service.dart';
import 'package:projects/internal/locator.dart';

class TFASmsController extends GetxController {
  final _service = locator<NumbersService>();

  var loaded = false.obs;
  var searching = false.obs;

  String _locale;
  List<CountryWithPhoneCode> _countries;
  RxList<CountryWithPhoneCode> countriesToShow;
  Rx<CountryWithPhoneCode> deviceCountry = null.obs;

  final _phoneCodeController = TextEditingController();
  MaskedTextController _phoneNumberController;
  TextEditingController get phoneCodeController => _phoneCodeController;
  MaskedTextController get phoneNumberController => _phoneNumberController;

  @override
  void onInit() async {
    loaded = false.obs;
    await _service.init();
    _locale = _service.localeCode;
    _countries = _service.countries;
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

  void onSearchPressed() => searching.toggle();
  void onSendCodePressed() => Get.toNamed('EnterSMSCodeScreen');

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
    _phoneNumberController.updateText('');
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
}
