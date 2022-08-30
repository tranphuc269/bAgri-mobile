import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/models/entities/role/role_entity.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/repositories/auth_repository.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/auth/login/login_cubit.dart';

import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:rxdart/rxdart.dart';

part 'account_list_state.dart';

class AccountListCubit extends Cubit<AccountListState>{
  AuthRepository? authRepository;
  AccountListCubit({this.authRepository}) : super(AccountListState());
  final showMessageController = PublishSubject<SnackBarMessage>();
  final accessToken = SharedPreferencesHelper.getToken().toString();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }

  void fetchAccountList() async{
    emit(state.copyWith(getListAccountStatus: LoginStatusBagri.LOADING));
    try{
      final response = await authRepository!.getListAcounts();
      if(response != null){
        emit(state.copyWith(
          getListAccountStatus: LoginStatusBagri.SUCCESS,
          listUserData: response
        ));
      }else{
        emit(state.copyWith(getListAccountStatus: LoginStatusBagri.FAILURE));
      }
      emit(state.copyWith(getListAccountStatus: LoginStatusBagri.SUCCESS));
    }catch(error){
      emit(state.copyWith(getListAccountStatus: LoginStatusBagri.FAILURE));
    }
  }

  void changeRole(RoleEntity? value) {
    emit(state.copyWith(role: value));
  }
  void isSelectedRoleState(bool? status){
    emit(state.copyWith(isSelectedRole: status));
  }

  Future <void> setRole(String id, String role) async{
    emit(state.copyWith(setRoleStatus: LoadStatus.LOADING));
    try{
      final response = await authRepository!.setRole(accessToken: accessToken, id: id, role: role);
      emit(state.copyWith(setRoleStatus: LoadStatus.SUCCESS));
    }catch(e){
      emit(state.copyWith(setRoleStatus: LoadStatus.FAILURE));
      showMessageController.sink.add(SnackBarMessage(
        message: S.current.error_occurred,
        type: SnackBarType.ERROR,
      ));
      return;

    }
  }

}