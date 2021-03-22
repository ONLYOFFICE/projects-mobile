import 'package:only_office_mobile/data/models/from_api/error.dart';

class ApiDTO<T> {
  ApiDTO({
    this.response,
    this.error,
  });
  T response;
  CustomError error;
}
