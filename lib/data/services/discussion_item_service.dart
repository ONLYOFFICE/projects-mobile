import 'package:projects/data/api/discussions_api.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class DiscussionItemService {
  final _api = locator<DiscussionsApi>();

  Future getMessageDetailed({int id}) async {
    var result = await _api.getMessageDetailed(id: id);
    var success = result.response != null;

    print('result.response ${result.response}');

    if (success) {
      return result.response;
    } else {
      ErrorDialog.show(result.error);
      return null;
    }
  }
}
