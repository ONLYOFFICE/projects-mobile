class Error {
  String message;
  Error({this.message});

  Error.fromJson(Map<String, dynamic> json) {
    message = json['error']['message'];
  }
}
