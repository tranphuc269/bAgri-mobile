import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/task/contract_task.dart';
import 'package:flutter_base/models/params/task/create_contract_task_params.dart';
import 'package:flutter_base/models/params/task/finish_contract_task_param.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class ContractTaskRepository{

  Future<dynamic> createContractTask({CreateContractTaskParam? param});
  Future<dynamic> getListContractTask();
  Future<dynamic> getListContractTaskBySeason({String? seasonId});
  Future<dynamic> deleteContractTask({String? contractTaskId});
  Future<dynamic> getContractTaskDetail({String? contractTaskId});
  Future <dynamic> updateContractTask({CreateContractTaskParam? param, String? contractTaskId});
  Future <dynamic> finishContractTask({FinishContractTaskParam? param,String? contractTaskId});
}
class ContractTaskRepositoryImpl extends ContractTaskRepository{
  ApiClient? _apiClientBagri;
  final accessToken = SharedPreferencesHelper.getToken().toString();
  ContractTaskRepositoryImpl(ApiClient? client){
    _apiClientBagri = client;
  }

  @override
  Future <void> createContractTask({CreateContractTaskParam? param}){
    final body = {
      "seasonId": param?.seasonId ?? "",
      "work": {
        "title": param?.work!.title ?? "",
        "unit": param?.work!.unit ?? "",
        "unitPrice": param?.work!.unitPrice ?? "",
      },
      "quantity" :param?.quantity ?? ""
    };
    return _apiClientBagri!.createContractTask("application/json", "Bearer ${accessToken}", "application/json", body);
  }

  Future <List<ContractTask>>getListContractTask() {
    return _apiClientBagri!.getListContractTask("application/json", "Bearer ${accessToken}");
  }
  Future<List<ContractTask>> getListContractTaskBySeason({String? seasonId}){
    return _apiClientBagri!.getListContractTaskBySeason("application/json", "Bearer ${accessToken}", seasonId);
}

  Future <dynamic> deleteContractTask({String? contractTaskId}){
    return _apiClientBagri!.deleteContractTask("application/json", "Bearer ${accessToken}", contractTaskId);
  }
  Future <ContractTask> getContractTaskDetail({String? contractTaskId}){
    return _apiClientBagri!.getContractTaskDetail("application/json", "Bearer ${accessToken}", contractTaskId);
  }

  Future <dynamic> updateContractTask({CreateContractTaskParam? param, String? contractTaskId}){
    final body = {
      "work": {
        "title": param?.work!.title ?? "",
        "unit": param?.work!.unit ?? "",
        "unitPrice": param?.work!.unitPrice ?? "",
      },
      "seasonId": param?.seasonId ?? "",
      "description": param?.description ?? "",
      "quantity" :param?.quantity ?? ""
    };
    return _apiClientBagri!.updateContractTask("application/json", "Bearer ${accessToken}", contractTaskId, "application/json", body);
  }
  Future <dynamic> finishContractTask({ FinishContractTaskParam? param,
    String? contractTaskId}){
    final body = {
      "materials": param?.materials ?? []
    };

    return _apiClientBagri!.finishContractTask("application/json", "Bearer ${accessToken}", contractTaskId, "application/json", body);
  }
}