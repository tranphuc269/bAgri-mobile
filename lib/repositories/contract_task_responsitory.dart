
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class ContractTaskRepository{

  // Future<dynamic> createContractTast();

}
class ContractTaskRepositoryImpl extends ContractTaskRepository{
  ApiClient? _apiClientBagri;
  final accessToken = SharedPreferencesHelper.getToken().toString();
  AuthRepositoryImpl(ApiClient? client) {
    _apiClientBagri = client;
  }

}