class ProjectTag {
  final int id;
  String title;
  String description;
  int status;

  ProjectTag({
    this.id,
    this.title,
    this.description,
    this.status,
  });

  factory ProjectTag.fromJson(Map<String, dynamic> json) => ProjectTag(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status,
      };
}
