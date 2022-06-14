

import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/params/contractWork/create_contract_work_param.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class ContractWorkRepositoy{

  Future<dynamic> getListContractWorks();
  Future<dynamic> createContractWork({CreateContractWorkParam? param});
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

  Future createContractWork({CreateContractWorkParam? param}){
    final body = {
      'title': param?.title ?? "",
      "unit" : param?.unit ?? "",
      "unitPrice": param?.unitPrice ?? ""
    };
    return _apiClientBagri!.createContractWork("application/json", "Bearer ${accessToken}", "application/json", body);
  }
}
