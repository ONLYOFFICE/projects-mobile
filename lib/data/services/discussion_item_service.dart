import 'package:projects/data/api/discussions_api.dart';
import 'package:projects/data/models/from_api/new_discussion_DTO.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class DiscussionItemService {
  final _api = locator<DiscussionsApi>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

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
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.discussion
      });
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
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.discussion
      });
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
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.discussion
      });
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
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.deleteEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.discussion
      });
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }
}
