import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_base/models/enums/load_status.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter_base/repositories/auth_repository.dart';
part 'registry_state.dart';

class RegistryCubit extends Cubit<RegistryState> {
  AuthRepository? repository;

  RegistryCubit({this.repository})
      : super(
            RegistryState(phone: '', email: '', password: '', name: ''));

  @override
  Future<void> close() {
    return super.close();
  }

  void registry(String name, String phone, String password, String email) async {
    emit(state.copyWith(RegisterStatus: LoadStatus.LOADING));
    try {
      final response = await repository!.authRegistty(name, phone, password, email);
      print(response);
      if (response != null) {
        emit(state.copyWith(RegisterStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(RegisterStatus: LoadStatus.FAILURE));
      }
    } catch (error) {
      if (error is DioError) {
        emit(state.copyWith(RegisterStatus: LoadStatus.FAILURE));
        if(error.response!.statusCode == 400){
          print("message: ");
          print(error.response!.data);
          if(error.response!.data['message'].toString().contains("Số điện thoại hoặc email đã tồn tại!")){
            emit(state.copyWith(
                messageError: "Số điện thoại hoặc email đã được sử dụng!",
                RegisterStatus: LoadStatus.FAILURE
            ));
          }
        }
        // logger.e(error.response!.data['error']['message']);
        // emit(state.copyWith(
        //     messageError: error.response!.data['error']['message'],
        //     RegisterStatus: LoadStatus.FAILURE));
      }
    }
  }

  void emailChange(String? email) {
    emit(state.copyWith(email: email));
  }

  void passChange(String? pass) {
    emit(state.copyWith(password: pass));
  }

  void changePhone(String? phone) {
    emit(state.copyWith(phone: phone));
  }

  void changeFullName(String? fullName) {
    emit(state.copyWith(name: fullName));
  }

}
