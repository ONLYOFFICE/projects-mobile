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
    ldapEnabled = json['response']['ldapEnabled'];
    providers = List<String>.from(json['response']['providers']);
    ssoLabel = json['response']['ssoLabel'];
    ldapEnabled = json['response']['ldapEnabled'];
  }
}
