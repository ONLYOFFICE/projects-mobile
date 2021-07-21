import 'package:projects/data/api/discussions_api.dart';
import 'package:projects/data/models/from_api/new_discussion_DTO.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class DiscussionItemService {
  final _api = locator<DiscussionsApi>();

  Future getMessageDetailed({int id}) async {
    var result = await _api.getMessageDetailed(id: id);
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }

  Future updateMessage({int id, NewDiscussionDTO discussion}) async {
    var result = await _api.updateMessage(id: id, discussion: discussion);
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }

  Future updateMessageStatus({int id, String newStatus}) async {
    var result = await _api.updateMessageStatus(id: id, newStatus: newStatus);
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }

  Future subscribeToMessage({int id}) async {
    var result = await _api.subscribeToMessage(id: id);
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }

  Future deleteMessage({int id}) async {
    var result = await _api.deleteMessage(id: id);
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }
}
