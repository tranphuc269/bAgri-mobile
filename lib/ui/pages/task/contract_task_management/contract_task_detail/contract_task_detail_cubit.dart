import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/task/contract_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/params/task/create_contract_task_params.dart';
import 'package:flutter_base/models/params/task/finish_contract_task_param.dart';
import 'package:flutter_base/repositories/contract_task_responsitory.dart';
import 'package:flutter_base/repositories/season_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contract_task_detail_state.dart';

class ContractTaskDetailCubit extends Cubit<ContractTaskDetailState>{
  ContractTaskRepository contractTaskRepository;
  SeasonRepository seasonRepository;
  ContractTaskDetailCubit({required this.contractTaskRepository, required this.seasonRepository}) : super(ContractTaskDetailState());

  Future<void> getContractTaskDetail(String id) async{
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try{
      final response = await contractTaskRepository.getContractTaskDetail(contractTaskId: id);
      if(response != null){
        emit(state.copyWith(loadStatus: LoadStatus.SUCCESS, contractTask: response, materials: response.materials));
        if(response.end != null){
          print(response.end);
          emit(state.copyWith(getFinishStatus: LoadStatus.SUCCESS));
        }else {
          emit(state.copyWith(getFinishStatus: LoadStatus.FAILURE));
        }

      }else{
        emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      }
    }catch(error){
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      throw error;
    }


  }

  Future<void> getSeasonDetail(String seasonId) async {
    emit(state.copyWith(getSeasonStatus: LoadStatus.LOADING));
    try {
      SeasonEntity result =
      await seasonRepository.getSeasonById(seasonId);
      emit(state.copyWith(
          getSeasonStatus: LoadStatus.SUCCESS, seasonEntity: result/*.data!.season!*/));
    } catch (e) {
      emit(state.copyWith(getSeasonStatus: LoadStatus.FAILURE));
    }
  }

  Future<void> addDescriptionForContrackTask(ContractTask?  contractTask, String? description) async {
    emit(state.copyWith(updateContractTaskStatus: LoadStatus.LOADING));
    CreateContractTaskParam param = CreateContractTaskParam(
      work: contractTask!.work,
      seasonId: contractTask.season,
      description: description,
      quantity: contractTask.quantity,
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
  Future<dynamic> finishContractTask(String? contractTaskId, List<MaterialUsedByTask> materials) async {
    emit(state.copyWith(finishContractTaskStatus: LoadStatus.LOADING));
    FinishContractTaskParam param = FinishContractTaskParam(
        materials: materials
    );
    try{
      final response = await contractTaskRepository.finishContractTask(contractTaskId: contractTaskId,param: param);
      print(response);
      if(response != null){
        emit(state.copyWith(finishContractTaskStatus: LoadStatus.SUCCESS));
      }else{
        emit(state.copyWith(finishContractTaskStatus: LoadStatus.FAILURE));
      }
    }catch (e){
      emit(state.copyWith(finishContractTaskStatus: LoadStatus.FAILURE));
      throw(e);
    }

  }

  void changeDescription(String? description){
    emit(state.copyWith(description: description));
    ContractTask temp = state.contractTask!;
    temp.description = description;
    emit(state.copyWith(contractTask: temp));
  }

}