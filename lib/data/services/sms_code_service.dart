import 'package:projects/data/api/authentication_api.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class SmsCodeService {
  final _api = locator<AuthApi>();

  Future setPhone({
    String userName,
    String password,
    String mobilePhone,
  }) async {
    var body = {
      'userName': userName,
      'password': password,
      'mobilePhone': mobilePhone
    };

    var result = await _api.setPhone(body);

    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      ErrorDialog.show(result.error);
      return null;
    }
  }

  Future sendSms({String userName, String password}) async {
    var body = {
      'userName': userName,
      'password': password,
    };

    var result = await _api.sendSms(body);

    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      ErrorDialog.show(result.error);
      return null;
    }
  }
}
