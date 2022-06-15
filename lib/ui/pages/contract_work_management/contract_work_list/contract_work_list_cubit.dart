import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/contract_work/contract_work.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/params/contractWork/create_contract_work_param.dart';
import 'package:flutter_base/repositories/auth_repository.dart';
import 'package:flutter_base/repositories/contract_work_reponsitory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

part 'contract_work_list_state.dart';

class ContractWorkListCubit extends Cubit<ContractWorkListState> {
  ContractWorkRepositoy? contractWorkRepositoy;

  ContractWorkListCubit({this.contractWorkRepositoy})
      : super(ContractWorkListState());

  void fetchContractWorkList() async {
    emit(state.copyWith(getListWorkStatus: LoadStatus.LOADING));
    try {
      final response = await contractWorkRepositoy!.getListContractWorks();
      if (response != null) {

        emit(state.copyWith(getListWorkStatus: LoadStatus.SUCCESS,
            listContractWork: response));
      } else {

        emit(state.copyWith(getListWorkStatus: LoadStatus.FAILURE));
      }
    } catch (error) {
      emit(state.copyWith(getListWorkStatus: LoadStatus.FAILURE));
      throw error;

    }
  }

  Future<void> createContractWork(String? unit) async {
    emit(state.copyWith(createContractWorkStatus: LoadStatus.LOADING));
    try {
      final param = CreateContractWorkParam(
          title: state.title, unit: unit, unitPrice:num.parse(state.unitPrice.toString()));
      final response =
          await contractWorkRepositoy!.createContractWork(param: param);
      if (response != null) {
        emit(state.copyWith(createContractWorkStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(createContractWorkStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      emit(state.copyWith(createContractWorkStatus: LoadStatus.FAILURE));
      throw e;
    }
  }
  Future <void> deleteContractWork(String? workId) async{
    emit(state.copyWith(deleteContractWorkStatus: LoadStatus.LOADING));
    try {
        final response = await contractWorkRepositoy!.deleteContractWork(workId: workId);
        if (response != null) {
          emit(state.copyWith(deleteContractWorkStatus: LoadStatus.SUCCESS));
        } else {
          emit(state.copyWith(deleteContractWorkStatus: LoadStatus.FAILURE));
        }
    }catch (e){
      emit(state.copyWith(deleteContractWorkStatus: LoadStatus.FAILURE));
      throw e;
    }
  }
  Future <void> modifyContractWork (String? workId, String? title,String? unit, String? unitPrice ) async{
    emit(state.copyWith(modifyContractWorkStatus: LoadStatus.LOADING));
    try {
      final param = CreateContractWorkParam(
          title: title, unit: unit, unitPrice:num.parse(unitPrice.toString()));
      final response = await contractWorkRepositoy!.modifyContractWork( workId: workId, param: param);
      if (response != null) {
        emit(state.copyWith(modifyContractWorkStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(modifyContractWorkStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      emit(state.copyWith(modifyContractWorkStatus: LoadStatus.FAILURE));
      throw e;
    }
  }

  void changeTitle(String title){
    emit(state.copyWith(title: title));
  }
  void changeUnitPrice(String unitPrice){
    emit(state.copyWith(unitPrice: unitPrice));
  }
}
