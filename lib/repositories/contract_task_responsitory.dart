
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/entities/task/contract_task.dart';
import 'package:flutter_base/models/params/task/create_contract_task_params.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class ContractTaskRepository{

  Future<dynamic> createContractTask({CreateContractTaskParam? param});
  Future<dynamic> getListContractTask();
  Future<dynamic> deleteContractTask({String? contractTaskId});

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
      "work": {
        "title": param?.work!.title ?? "",
        "unit": param?.work!.unit ?? "",
        "unitPrice": param?.work!.unitPrice ?? "",
      },
      "garden": param?.gardenName ?? "",
      "treeQuantity" :param?.treeQuantity ?? ""
    };
    return _apiClientBagri!.createContractTask("application/json", "Bearer ${accessToken}", "application/json", body);
  }

  Future <List<ContractTask>>getListContractTask() {
    return _apiClientBagri!.getListContractTask("application/json", "Bearer ${accessToken}");
  }
  
  Future <dynamic> deleteContractTask({String? contractTaskId}){
    return _apiClientBagri!.deleteContractTask("application/json", "Bearer ${accessToken}", contractTaskId);
  }
}