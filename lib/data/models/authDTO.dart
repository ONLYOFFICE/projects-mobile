import 'package:only_office_mobile/data/models/auth_token.dart';
import 'package:only_office_mobile/data/models/error.dart';

class AuthDTO {
  AuthDTO({
    this.authToken,
    this.error,
  });
  AuthToken authToken;
  PortalError error;
}
