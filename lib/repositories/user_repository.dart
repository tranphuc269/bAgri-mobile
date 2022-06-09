import 'package:flutter_base/models/entities/manager/manager_entity.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/response/object_response.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class UserRepository {
  Future<UserEntity> getProfile(String token);

  Future<List<UserEntity>> getListManager(String token);
}

class UserRepositoryImpl extends UserRepository {
  ApiClient? _apiClient;

  UserRepositoryImpl(ApiClient? client) {
    _apiClient = client;
  }

  @override
  Future<UserEntity> getProfile(String token) {
    return _apiClient!.getUserData("application/json", token);
  }

  @override
  Future<List<UserEntity>> getListManager(String token) async {
    return _apiClient!.getListAccounts("application/json", token);
  }
}
