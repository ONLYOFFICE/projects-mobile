class CustomError {
  String message;
  CustomError({this.message});

  CustomError.fromJson(Map<String, dynamic> json) {
    message = json['error']['message'];
  }
}
