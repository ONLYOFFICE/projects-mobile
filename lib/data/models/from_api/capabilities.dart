class Capabilities {
  Capabilities({
    this.ldapEnabled,
    this.providers,
    this.ssoLabel,
    this.ssoUrl,
  });
  bool ldapEnabled;
  List<String> providers;
  String ssoLabel;
  String ssoUrl;

  Capabilities.fromJson(Map<String, dynamic> json) {
    ldapEnabled = json['ldapEnabled'];
    providers = List<String>.from(json['providers']);
    ssoLabel = json['ssoLabel'];
    ldapEnabled = json['ldapEnabled'];
  }
}
