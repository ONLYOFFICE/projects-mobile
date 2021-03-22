import 'package:projects/data/models/from_api/error.dart';

class ApiDTO<T> {
  ApiDTO({
    this.response,
    this.error,
  });
  T response;
  CustomError error;
}
