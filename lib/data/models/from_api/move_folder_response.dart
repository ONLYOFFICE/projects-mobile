import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';

class MoveFolderResponse {
  String id;
  int operation;
  int progress;
  String error;
  String processed;
  bool finished;
  String url;
  List<PortalFile> files;
  List<Folder> folders;

  MoveFolderResponse(
      {this.id,
      this.operation,
      this.progress,
      this.error,
      this.processed,
      this.finished,
      this.url,
      this.files,
      this.folders});

  MoveFolderResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operation = json['operation'];
    progress = json['progress'];
    error = json['error'];
    processed = json['processed'];
    finished = json['finished'];
    url = json['url'];
    if (json['files'] != null) {
      files = <PortalFile>[];
      json['files'].forEach((v) {
        files.add(PortalFile.fromJson(v));
      });
    }
    if (json['folders'] != null) {
      folders = <Folder>[];
      json['folders'].forEach((v) {
        folders.add(Folder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['operation'] = operation;
    data['progress'] = progress;
    data['error'] = error;
    data['processed'] = processed;
    data['finished'] = finished;
    data['url'] = url;
    if (files != null) {
      data['files'] = files.map((v) => v.toJson()).toList();
    }
    if (folders != null) {
      data['folders'] = folders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
