import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/role/role_entity.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';

import 'package:flutter_base/repositories/auth_repository.dart';
import 'package:flutter_base/repositories/user_repository.dart';

import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

part 'login_state.dart';

enum LoginNavigator {
  OPEN_HOME,
  OPEN_GARDEN_MANAGER_HOME
}

class LoginCubit extends Cubit<LoginState> {
  AuthRepository? repository;
  UserRepository userRepository;

  LoginCubit({this.repository, required this.userRepository})
      : super(LoginState());

  final navigatorController = PublishSubject<LoginNavigator>();
  final showMessageController = PublishSubject<SnackBarMessage>();

  @override
  Future<void> close() {
    navigatorController.close();
    showMessageController.close();
    return super.close();
  }

  void clearInformation() {
    emit(state.copyWith(username: "", password: ""));
  }
  void  signIn(String phonenumer, String password) async {
    //validate
    if (phonenumer.isEmpty) {
      showMessageController.sink.add(SnackBarMessage(
        message: 'Chưa nhập số điện thoại ',
        type: SnackBarType.ERROR,
      ));
      return;
    }
    if (password.isEmpty) {
      showMessageController.sink.add(SnackBarMessage(
        message: 'Chưa nhập mật khẩu',
        type: SnackBarType.ERROR,
      ));
      return;
    }
    //emit(state.copyWith(LoginStatus: LoginStatusBagri.LOADING));
    try {
      final result = await repository!.signIn(phonenumer, password);
      SharedPreferencesHelper.setToken(result.access_token!);
      GlobalData.instance.token = result.access_token;
      emit(state.copyWith(LoginStatus: LoginStatusBagri.SUCCESS));
      if (result.access_token != null) {
        try {
          final UserEntity userRes =
              await userRepository.getProfile(SharedPreferencesHelper.getToken().toString());
          print(userRes.role);
          if(userRes.role == "NO_ROLE"){
            showMessageController.sink.add(SnackBarMessage(
              message: "Tài khoản chưa được cấp quyền, vui lòng liên hệ người quản lý",
              type: SnackBarType.ERROR,
            ));
          } else if (userRes.role == 'SUPER_ADMIN') {
            navigatorController.sink.add(LoginNavigator.OPEN_HOME);
          } else if (userRes.role == "ADMIN") {
            // navigatorController.sink.add(LoginNavigator.OPEN_GARDEN);
            navigatorController.sink.add(LoginNavigator.OPEN_HOME);
          }else if (userRes.role == "GARDEN_MANAGER"){
            navigatorController.sink.add(LoginNavigator.OPEN_GARDEN_MANAGER_HOME);
          }else{
            navigatorController.sink.add(LoginNavigator.OPEN_HOME);
          }
          SharedPreferencesHelper.setRole(userRes.role ?? "");
          GlobalData.instance.role = userRes.role;
          SharedPreferencesHelper.setUserInfo(userRes);
          GlobalData.instance.userEntity = userRes;
        } catch (error) {
          logger.e(error);
          if (error is DioError) {
            emit(state.copyWith(LoginStatus: LoginStatusBagri.FAILURE));
            showMessageController.sink.add(SnackBarMessage(
              message: error.response!.data['error']['message'],
              type: SnackBarType.ERROR,
            ));
          }
        }
      } else {
        emit(state.copyWith(LoginStatus: LoginStatusBagri.FAILURE));
      }
    } catch (error) {
      logger.e(error);
      if (error is DioError) {
        emit(state.copyWith(LoginStatus: LoginStatusBagri.FAILURE));
        if(error.response!.statusCode == 400){
          showMessageController.sink.add(SnackBarMessage(
          message: "Thông tin tài khoản mật khẩu không chính xác!",
          type: SnackBarType.ERROR,
        ));}

      }
    }
  }

  void usernameChange(String username) {
    emit(state.copyWith(username: username));
  }

  void passChange(String pass) {
    emit(state.copyWith(password: pass));
  }

  void changeRole(RoleEntity? value) {
    emit(state.copyWith(role: value));
  }
}
