
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/auth_repository.dart';
import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'otp_authentication_state.dart';
class OtpAuthenticationCubit extends Cubit<OtpAuthenticationState>{
  AuthRepository? authRepository;

  OtpAuthenticationCubit({this.authRepository}) :super(OtpAuthenticationState());
  final showMessageController = PublishSubject<SnackBarMessage>();

 Future <void> AuthOtp(String? email, String? otp, String? newPassword) async {
    emit(state.copyWith(OtpAuthStatus: LoadStatus.LOADING));
    try{
      final response = await authRepository!.resetPasswordFinish(email: email, otp: otp, newPassword: newPassword);
      if (response != null){
        emit(state.copyWith(OtpAuthStatus: LoadStatus.SUCCESS));
      }else{
        emit(state.copyWith(OtpAuthStatus: LoadStatus.FAILURE));
      }
    }catch(error){
      if (error is DioError) {
        emit(state.copyWith(OtpAuthStatus:LoadStatus.FAILURE));
      throw(error);
      }
    }
  }

}

