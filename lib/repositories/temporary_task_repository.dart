import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class TemporaryTaskRepository {
  Future<List<TemporaryTask>> getListTemporaryTask();
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
}
