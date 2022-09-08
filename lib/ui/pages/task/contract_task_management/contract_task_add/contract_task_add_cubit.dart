import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/contract_work/contract_work.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';

import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/params/task/create_contract_task_params.dart';
import 'package:flutter_base/repositories/contract_task_responsitory.dart';

part 'contract_task_add_state.dart';

class ContractTaskAddingCubit extends Cubit<ContractTaskAddingState> {
  ContractTaskRepository contractTaskRepository;

  ContractTaskAddingCubit({required this.contractTaskRepository})
      : super(ContractTaskAddingState());

  void changeSeason(SeasonEntity value) {
    emit(state.copyWith(seasonEntity: value));
  }

  void changeWork(ContractWorkEntity value) {
    emit(state.copyWith(contractWorkEntity: value));
  }

  void changeStartTime(String startTime) {
    emit(state.copyWith(startTime: startTime));
  }

  void changeTreePlaceQuantity(String treePlaceQuantity) {
    emit(state.copyWith(treePlaceQuantityMax: treePlaceQuantity));
  }

  Future<void> createContractTask(String? treeQuantity, String? seasonId) async {
    emit(state.copyWith(addContractTaskStatus: LoadStatus.LOADING));
    try {
      CreateContractTaskParam param = CreateContractTaskParam(
          work: state.contractWorkEntity,
          seasonId: seasonId,
          quantity: int.tryParse(treeQuantity.toString()));
      final response =
          await contractTaskRepository.createContractTask(param: param);
      print(response);
      if (response != null) {
        emit(state.copyWith(addContractTaskStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(addContractTaskStatus: LoadStatus.FAILURE));
      }
    } catch (error) {
      print(error);
      emit(state.copyWith(addContractTaskStatus: LoadStatus.FAILURE));
      throw error;
    }
  }
}
