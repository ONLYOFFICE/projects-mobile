class NewDiscussionDTO {
  NewDiscussionDTO({
    this.title,
    this.content,
    this.participants,
    this.notify,
  });

  final bool notify;
  final String title;
  final String content;
  final List<String> participants;

  Map<String, dynamic> toJson() {
    // ignore: omit_local_variable_types
    String part = participants.join(',');

    return {
      'title': title,
      'content': content,
      'participants': part,
      'notify': notify,
    };
  }
}
