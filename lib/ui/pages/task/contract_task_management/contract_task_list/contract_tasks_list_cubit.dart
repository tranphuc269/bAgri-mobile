
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/task/contract_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/params/task/finish_contract_task_param.dart';
import 'package:flutter_base/repositories/contract_task_responsitory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contract_tasks_list_state.dart';

class ContractTaskListCubit extends Cubit<ContractTaskListState> {
  ContractTaskRepository? contractTaskRepositoy;

  ContractTaskListCubit({this.contractTaskRepositoy})
      : super(ContractTaskListState());

  Future <void> fetchListContractTask({String? seasonId}) async {
    emit(state.copyWith(getListContractTaskStatus: LoadStatus.LOADING));
    try {
     final response = await contractTaskRepositoy!.getListContractTask/*BySeason*/(/*seasonId: seasonId*/);
     print("response contract task: ");
   //  print(response.toString());
      if (response != null) {
        emit(state.copyWith(getListContractTaskStatus: LoadStatus.SUCCESS,
            listContractTasks: response));
      } else {

        emit(state.copyWith(getListContractTaskStatus: LoadStatus.FAILURE));
      }
    } catch (error) {
      emit(state.copyWith(getListContractTaskStatus: LoadStatus.FAILURE));
      throw error;
    }
  }
  Future <void> deleteContractTask(String? contractTaskId) async {
    emit(state.copyWith(deleteContractTaskStatus: LoadStatus.LOADING));
    try{
      final response = await contractTaskRepositoy!.deleteContractTask(contractTaskId: contractTaskId);
      if (response != null){
        emit(state.copyWith(deleteContractTaskStatus: LoadStatus.SUCCESS));
      }else {
        emit(state.copyWith(deleteContractTaskStatus: LoadStatus.FAILURE));
      }
    }catch (error){
      emit(state.copyWith(deleteContractTaskStatus: LoadStatus.FAILURE));
      throw error;
    }
  }



}
