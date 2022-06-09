import 'package:flutter_base/models/entities/process/list_process.dart';
import 'package:flutter_base/models/entities/process/process_delete.dart';
import 'package:flutter_base/models/entities/process/process_detail.dart';
import 'package:flutter_base/models/params/process/create_process_params.dart';
import 'package:flutter_base/models/response/object_response.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class ProcessRepository {
  Future<ProcessDataEntity> getListProcessData();

  Future<ProcessDeleteResponse> deleteProcess({String? processId});

  Future<dynamic> createProcess({ProcessEntity? param});

  Future<dynamic> updateProcess({String? processId, ProcessEntity? param});

  Future<ProcessEntity> getProcessById(
      String processId);

  Future<ProcessDataEntity> getProcessOfTree(String treeId);
}

class ProcessRepositoryImpl extends ProcessRepository {
  ApiClient? _apiClient;

  ProcessRepositoryImpl(ApiClient? client) {
    _apiClient = client;
  }

  @override
  Future<ProcessDataEntity> getListProcessData() async {
    // return await _apiClient!.getListProcessData({});
    return await AppApi.instance.getListProcessData();
  }

  Future<ProcessDeleteResponse> deleteProcess({String? processId}) async {
    return await _apiClient!.deleteProcess(processId: processId);
  }

  Future<dynamic> createProcess({ProcessEntity? param}) {
    // final body = {
    //   "name": param?.name ?? "",
    //   "tree_ids": param?.tree_ids ?? [],
    //   "stages": param?.stages ?? [],
    // };

    return _apiClient!.createProcess(param!.toJson());
  }

  Future<dynamic> updateProcess(
      {String? processId, ProcessEntity? param}) {
    final body = {
      'name': param?.name,
      'trees': param?.trees!.map((e) => e.toJson()).toList(),
      'phases': param?.stages!.map((e) => e.toJson()).toList(),
    };
    return _apiClient!.updateProcess(processId, body);
  }

  @override
  Future<ProcessEntity> getProcessById(
      String processId) async {
    return await _apiClient!.getProcessById(processId);
  }

  @override
  Future<ProcessDataEntity> getProcessOfTree(String treeId) async {
    return await _apiClient!.getProcessOfTree(treeId);
  }
}
