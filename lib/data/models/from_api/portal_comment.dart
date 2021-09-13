class PortalComment {
  bool inactive;
  bool isEditPermissions;
  bool isRead;
  bool isResponsePermissions;
  dynamic attachments;
  List<PortalComment> commentList;
  String commentBody;
  String commentId;
  String timeStampStr;
  String userAvatarPath;
  String userFullName;
  String userId;
  String userPost;
  String userProfileLink;

  PortalComment({
    this.attachments,
    this.commentBody,
    this.commentId,
    this.commentList,
    this.inactive,
    this.isEditPermissions,
    this.isRead,
    this.isResponsePermissions,
    this.timeStampStr,
    this.userAvatarPath,
    this.userFullName,
    this.userId,
    this.userPost,
    this.userProfileLink,
  });
  factory PortalComment.fromJson(Map<String, dynamic> json) => PortalComment(
        commentId: json['commentID'],
        userId: json['userID'],
        userPost: json['userPost'],
        userFullName: json['userFullName'],
        userProfileLink: json['userProfileLink'],
        userAvatarPath: json['userAvatarPath'],
        commentBody: json['commentBody'],
        inactive: json['inactive'],
        isRead: json['isRead'],
        isEditPermissions: json['isEditPermissions'],
        isResponsePermissions: json['isResponsePermissions'],
        timeStampStr: json['timeStampStr'],
        commentList: (json['commentList'] != null)
            ? List<PortalComment>.from(
                json['commentList'].map((x) => PortalComment.fromJson(x)))
            : null,
        attachments: json['attachments'],
      );

  Map<String, dynamic> toJson() => {
        'commentID': commentId,
        'userID': userId,
        'userPost': userPost,
        'userFullName': userFullName,
        'userProfileLink': userProfileLink,
        'userAvatarPath': userAvatarPath,
        'commentBody': commentBody,
        'inactive': inactive,
        'isRead': isRead,
        'isEditPermissions': isEditPermissions,
        'isResponsePermissions': isResponsePermissions,
        'timeStampStr': timeStampStr,
        'commentList': List<dynamic>.from(commentList.map((x) => x.toJson())),
        'attachments': attachments,
      };

  bool get hasDisplayedReplies {
    for (var item in commentList) if (!item.inactive) return true;
    return false;
  }

  bool get show => !inactive || hasDisplayedReplies;
}
