class PortalGroup {
  PortalGroup({
    this.id,
    this.name,
    this.manager,
  });

  String id;
  String name;
  String manager;

  factory PortalGroup.fromJson(Map<String, dynamic> json) => PortalGroup(
        id: json['id'],
        name: json['name'],
        manager: json['manager'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'manager': manager,
      };
}
