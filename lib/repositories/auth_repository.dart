import 'package:dio/dio.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/entities/token/login_model.dart';
import 'package:flutter_base/network/api_client_bagri.dart';

abstract class AuthRepository {
  //
  Future<void> removeToken();

  Future<LoginResponseEntity> signIn(String username, String password);

  Future<dynamic> authRegistty(String username, String password,
      String fullname, String phone);

  Future<dynamic> changePassword(
      String oldPass, String newPass, String confirmedPass);

  Future<dynamic> forgotPassword(String userName, String phone);

  Future<dynamic> getListAcounts();
}

class AuthRepositoryImpl extends AuthRepository {
  ApiClient? _apiClientBagri;

  AuthRepositoryImpl(ApiClient? client) {
    _apiClientBagri = client;
  }


  @override
  Future<void> removeToken() async {
    SharedPreferencesHelper.removeToken();
  }

  @override
  Future<LoginResponseEntity> signIn(String username, String password) async {
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
    return _apiClientBagri!.getListAccounts("application/json", "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MjhjYWU4ZmIzZjNkOWY4ZjNhZDgzNGYiLCJ1c2VybmFtZSI6ImR1Y25tIiwicm9sZSI6IlNVUEVSX0FETUlOIiwiaWF0IjoxNjUzNTQzODA5LCJleHAiOjE2NTQxNDg2MDl9.yjMCo25gm_WvJ1uRFZ37QCkfk9wpVndeWH7xyl3Be1Q");
  }
}
