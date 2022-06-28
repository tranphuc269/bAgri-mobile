import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class TemporaryTaskRepository {
  Future<List<TemporaryTask>> getListTemporaryTask();
  Future<dynamic> deleteTemporaryTask(String id);
  Future<dynamic> createTemporaryTask(TemporaryTask temporaryTask);
  Future<dynamic> updateTemporaryTask(TemporaryTask temporaryTask,  String? temporaryTaskId);
  Future<TemporaryTask> getTemporaryTaskById(String? id);
}

class TemporaryTaskRepositoryImpl extends TemporaryTaskRepository {
  ApiClient? _apiClientBagri;

  TemporaryTaskRepositoryImpl(ApiClient? client) {
    this._apiClientBagri = client;
  }

  @override
  Future<List<TemporaryTask>> getListTemporaryTask() {
    return _apiClientBagri!.getListTemporaryTasks();
  }

  @override
  Future deleteTemporaryTask(String id) {
    return _apiClientBagri!.deleteTemporaryTask(id);
  }

  @override
  Future createTemporaryTask(TemporaryTask temporaryTask) {
    return _apiClientBagri!.createTemporaryTask(temporaryTask.toJson());
  }

  @override
  Future updateTemporaryTask(TemporaryTask temporaryTask, String? temporaryTaskId) {
    return _apiClientBagri!.updateTemporaryTask(temporaryTask.toJson(), temporaryTaskId);
  }

  @override
  Future<TemporaryTask> getTemporaryTaskById(String? id) {
    return _apiClientBagri!.getTemporaryTaskById(id);
  }

}
