import 'package:get/get.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/domain/controllers/tasks/sort_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class TaskService {
  final TaskApi _api = locator<TaskApi>();

  var portalTask = PortalTask().obs;

  Future getTaskByID({int id}) async {
    var task = await _api.getTaskByID(id: id);

    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      ErrorDialog.show(task.error);
      return null;
    }
  }

  Future getTasks({params = ''}) async {
    var tasks = await _api.getTasks(params: params);

    var success = tasks.response != null;

    if (success) {
      return tasks.response;
    } else {
      ErrorDialog.show(tasks.error);
      return null;
    }
  }

  Future getFilteredAndSortedTasks({String filters, String sort}) async {
    // Вся проблема в том, что не получается использовать фильтры и сортировку
    // в своих контроллерах и в них совершать обновления после новых фильтров.
    // Контроллеры сортировки и фильтров должны ссылаться на глобальный
    // контроллер тасков, чтобы вызвать getTasks. Но проблема в том, что в самом
    // TasksController также нужно использовать SortC. FiltersC., чтобы, например,
    // не потерять текущие настройки при обновлении или при выборе сортировки без
    // фильтров и наоборот. В итоге получится, что SortC ищет глобальный TasksC.,
    // а TasksC ищет одновременно SortC => ошибка Stack overflow (я так понял, ошибка)
    // из-за этого. Моим решением было сохранять все в TasksService, потому что
    // если его вызвать через locator, все норм. Надеюсь, понятно.

    // if you only want to filter, without sorting
    if (filters == null) {
      final _filterController = Get.find<TaskFilterController>();
      filters = _filterController.acceptedFilters.value;
    }
    if (sort == null) {
      final _sortController = Get.find<TasksSortController>();
      sort = _sortController.sort;
    }

    var params = filters + sort;
    var tasks = await _api.getTasks(params: params);

    var success = tasks.response != null;

    if (success) {
      return tasks.response;
    } else {
      ErrorDialog.show(tasks.error);
      return null;
    }
  }

  Future getStatuses() async {
    var statuses = await _api.getStatuses();

    var success = statuses.response != null;

    if (success) {
      return statuses.response;
    } else {
      ErrorDialog.show(statuses.error);
      return null;
    }
  }
}
