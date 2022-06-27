
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/task/contract_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/params/task/create_contract_task_params.dart';
import 'package:flutter_base/repositories/contract_task_responsitory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contract_task_detail_state.dart';

class ContractTaskDetailCubit extends Cubit<ContractTaskDetailState>{
  ContractTaskRepository contractTaskRepository;
  ContractTaskDetailCubit({required this.contractTaskRepository}) : super(ContractTaskDetailState());

  Future<void> getContractTaskDetail(String id) async{
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try{
      final response = await contractTaskRepository.getContractTaskDetail(contractTaskId: id);
      if(response != null){
        print(response);
        emit(state.copyWith(loadStatus: LoadStatus.SUCCESS, contractTask: response));
      }else{
        emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      }
    }catch(error){
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      throw error;
    }


  }

  Future<void> addDescriptionForContrackTask(ContractTask?  contractTask, String? description) async {
    emit(state.copyWith(updateContractTaskStatus: LoadStatus.LOADING));
    CreateContractTaskParam param = CreateContractTaskParam(
      work: contractTask!.work,
      gardenName: contractTask.gardenName,
      description: description,
      treeQuantity: contractTask.treeQuantity,
    );
    try{
      final response = contractTaskRepository.updateContractTask(param: param, contractTaskId: contractTask.id );
      if(response != null){
        emit(state.copyWith(updateContractTaskStatus: LoadStatus.SUCCESS));
      }else{
        emit(state.copyWith(updateContractTaskStatus: LoadStatus.FAILURE));
      }
    } catch(e){
      emit(state.copyWith(updateContractTaskStatus: LoadStatus.FAILURE));
      throw e;
    }
  }
  void addList(MaterialUsedByTask value) {
    emit(state.copyWith(addMaterialStatus: LoadStatus.LOADING_MORE));
    List<MaterialUsedByTask> material = state.materials!;
    material.add(value);
    List<MaterialUsedByTask> newList = material;
    emit(state.copyWith(
        materials: newList,
        addMaterialStatus: LoadStatus.FORMAT_EXTENSION_FILE));
  }

}