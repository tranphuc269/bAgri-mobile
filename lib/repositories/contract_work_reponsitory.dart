

import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/entities/task/work.dart';
import 'package:flutter_base/models/params/contractWork/create_contract_work_param.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class ContractWorkRepositoy{

  Future<dynamic> getListContractWorks();
  Future<dynamic> createContractWork({CreateContractWorkParam? param});
  Future<dynamic> deleteContractWork({String? workId});
  Future<dynamic> modifyContractWork({String? workId, CreateContractWorkParam? param });
}

class ContractWorkRepositoryImpl extends ContractWorkRepositoy{

  ApiClient? _apiClientBagri;
  final accessToken = SharedPreferencesHelper.getToken().toString();
  ContractWorkRepositoryImpl(ApiClient? client) {
    _apiClientBagri = client;
  }
  @override
  Future getListContractWorks() {
   return _apiClientBagri!.getListContractWork("application/json","Bearer ${accessToken}");
  }

  Future <void>createContractWork({CreateContractWorkParam? param}){
    final body = {
      'title': param?.title ?? "",
      "unit" : param?.unit ?? "",
      "unitPrice": param?.unitPrice ?? ""
    };
    return _apiClientBagri!.createContractWork("application/json", "Bearer ${accessToken}", "application/json", body);
  }
  Future <void> deleteContractWork({String? workId})  {
    return _apiClientBagri!.deleteContractWork("application/json", "Bearer ${accessToken}", workId);
  }

  Future <void> modifyContractWork({String? workId, CreateContractWorkParam? param}){
    final body = {
      'title': param?.title ?? "",
      "unit" : param?.unit ?? "",
      "unitPrice": param?.unitPrice ?? ""
    };
    return _apiClientBagri!.modifyContractWork("application/json", "Bearer ${accessToken}", "application/json", workId, body);
  }

}
