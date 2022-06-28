import 'package:dio/dio.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/entities/garden_task/task_entity.dart';
import 'package:flutter_base/models/entities/process/step_entity.dart';
import 'package:flutter_base/models/entities/token/login_model.dart';
import 'package:flutter_base/network/api_client_bagri.dart';
import 'package:retrofit/dio.dart';

abstract class AuthRepository {
  //
  Future<void> removeToken();

  Future<TokenEntity> signIn(String username, String password);

  Future<dynamic> authRegistty(String name, String phone, String password, String email);

  Future<dynamic> changePassword(
      String oldPass, String newPass);

  Future<dynamic> forgotPassword({String? email});
  Future<dynamic> getListAcounts();
  Future <dynamic> setRole({String? accessToken, String? id, String? role});
  Future<List<StepEntityResponseByDay>> getStepsByDay({String? day});
  Future<dynamic> resetPasswordFinish({String? email, String? otp, String? newPassword});
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
  Future<TokenEntity> signIn(String phonenumber, String password) async {
    final param = {
      'phone': phonenumber,
      'password': password,
    };
    return _apiClientBagri!.authLogin(param);
  }

  @override
  Future<dynamic> authRegistty(String name,String phone, String password,
   String email ) async {
    final param = {
      'name': name,
      'phone': phone,
      'password': password,
      'email': email,
    };
    return _apiClientBagri!.authRegistty(param);
  }

  @override
  Future<dynamic> changePassword(
      String oldPass, String newPass) async {
    final param = {
      "oldPassword": oldPass,
      "newPassword": newPass,
    };
    return _apiClientBagri!.changePassword("*/*","Bearer ${accessToken}","application/json",param);
  }

  @override
  Future<dynamic> forgotPassword({String? email}) async {
    return _apiClientBagri!.forgotPassword("*/*", email);
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
  Future <List<StepEntityResponseByDay>>getStepsByDay({String? day}) async {
    return await _apiClientBagri!.getStepsByDay("application/json","Bearer ${accessToken}",day);
  }

  @override
  Future <dynamic> resetPasswordFinish({String? email, String? otp, String? newPassword}) async {
    final body = {
      "email" : email,
      "otp": otp,
      "newPassword": newPassword
    };
    return await _apiClientBagri!.AuthOtp("*/*", "application/json", body);
  }

}
