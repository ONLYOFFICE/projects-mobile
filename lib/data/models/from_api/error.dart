import 'package:easy_localization/easy_localization.dart';

class CustomError {
  String message;
  CustomError({message}) {
    message ??= '';
    this.message = _customErrors[message] ?? message;
  }

  CustomError.fromJson(Map<String, dynamic> json) {
    var text = json['message'] ?? '';
    message = _customErrors[text] ?? text;
  }
}

// TODO custom errors
Map _customErrors = {
  'User authentication failed': tr('authenticationFailed'),
  'No address associated with hostname': tr('noAdress'),
};
