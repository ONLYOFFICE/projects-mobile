import 'package:projects/data/models/from_api/error.dart';

class ApiDTO<T> {
  ApiDTO({
    this.response,
    this.error,
  });
  T response;
  CustomError error;
}

class ProjectsApiDTO<T> {
  ProjectsApiDTO({
    this.response,
    this.error,
    this.startIndex,
    this.total,
  });
  T response;
  CustomError error;
  int startIndex;

  int total;
}
