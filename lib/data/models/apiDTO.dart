import 'package:only_office_mobile/data/models/error.dart';

class ApiDTO<T> {
  ApiDTO({
    this.response,
    this.error,
  });
  T response;
  PortalError error;
}
