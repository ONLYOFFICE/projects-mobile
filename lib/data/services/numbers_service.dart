import 'package:devicelocale/devicelocale.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

class NumbersService {
  final _numbers = FlutterLibphonenumber();
  String _locale;

  Future<void> init() async {
    await _numbers.init();
    await CountryManager().loadCountries();
    _locale = await Devicelocale.currentLocale;
  }

  List get countries => CountryManager().countries;
  String get localeCode =>
      _locale.substring(_locale.indexOf('_') + 1 ?? 0, _locale.length);
}
