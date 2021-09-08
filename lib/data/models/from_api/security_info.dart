class SecrityInfo {
  bool canCreateProject;
  bool canCreateTask;
  bool canCreateMilestone;
  bool canCreateMessage;
  bool canCreateTimeSpend;

  SecrityInfo(
      {this.canCreateProject,
      this.canCreateTask,
      this.canCreateMilestone,
      this.canCreateMessage,
      this.canCreateTimeSpend});

  SecrityInfo.fromJson(Map<String, dynamic> json) {
    canCreateProject = json['canCreateProject'];
    canCreateTask = json['canCreateTask'];
    canCreateMilestone = json['canCreateMilestone'];
    canCreateMessage = json['canCreateMessage'];
    canCreateTimeSpend = json['canCreateTimeSpend'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['canCreateProject'] = canCreateProject;
    data['canCreateTask'] = canCreateTask;
    data['canCreateMilestone'] = canCreateMilestone;
    data['canCreateMessage'] = canCreateMessage;
    data['canCreateTimeSpend'] = canCreateTimeSpend;
    return data;
  }
}
