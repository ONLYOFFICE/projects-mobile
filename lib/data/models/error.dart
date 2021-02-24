class PortalError {
  String message;
  PortalError({this.message});

  PortalError.fromJson(Map<String, dynamic> json) {
    message = json['error']['message'];
  }
}
