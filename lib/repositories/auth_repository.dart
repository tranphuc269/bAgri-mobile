import 'package:dio/dio.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/entities/token/login_model.dart';
import 'package:flutter_base/network/api_client_bagri.dart';
import 'package:retrofit/dio.dart';

abstract class AuthRepository {
  //
  Future<void> removeToken();

  Future<TokenEntity> signIn(String username, String password);

  Future<dynamic> authRegistty(String username, String password,
      String fullname, String phone);

  Future<dynamic> changePassword(
      String oldPass, String newPass, String confirmedPass);

  Future<dynamic> forgotPassword(String userName, String phone);

  Future<dynamic> getListAcounts();

  Future <dynamic> setRole({String? accessToken, String? id, String? role});
}

class AuthRepositoryImpl extends AuthRepository {
  ApiClient? _apiClientBagri;
  final accessToken = SharedPreferencesHelper.getToken().toString();
  AuthRepositoryImpl(ApiClient? client) {
    _apiClientBagri = client;
  }


  @override
  Future<void> removeToken() async {
    SharedPreferencesHelper.removeToken();
  }

  @override
  Future<TokenEntity> signIn(String username, String password) async {
    final param = {
      'username': username,
      'password': password,
    };
    return _apiClientBagri!.authLogin(param);
  }

  @override
  Future<dynamic> authRegistty(String username, String password,
      String fullname, String phone) async {
    final param = {
      'username': username,
      'password': password,
      'name': fullname,
      'phone': phone,
    };
    return _apiClientBagri!.authRegistty(param);
  }

  @override
  Future<dynamic> changePassword(
      String oldPass, String newPass, String confirmedPass) async {
    final param = {
      'old_password': oldPass,
      'new_password': newPass,
      'retype_new_password': confirmedPass,
    };
    return _apiClientBagri!.changePassword(param);
  }

  @override
  Future<dynamic> forgotPassword(String userName, String phone) async {
    final param = {
      'username': userName,
      'phone': phone,
    };
    return _apiClientBagri!.forgotPassword(param);
  }

  @override
  Future getListAcounts()  async {
    return _apiClientBagri!.getListAccounts("application/json", "Bearer ${accessToken}");
  }

  @override
  Future setRole({String? id, String? role, String? accessToken}) async {
    final param  = {
      "role": role
    };
    return await _apiClientBagri!.setRoleAccount("application/json","Bearer ${accessToken}","application/json",id, param);
  }

}
