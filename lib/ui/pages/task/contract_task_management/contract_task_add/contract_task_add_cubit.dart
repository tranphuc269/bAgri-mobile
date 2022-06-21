import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/configs/app_config.dart';
import 'package:flutter_base/models/entities/contract_work/contract_work.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/process/list_process.dart';
import 'package:flutter_base/models/entities/process/process_detail.dart';
import 'package:flutter_base/models/entities/process/stage_entity.dart';
import 'package:flutter_base/models/entities/process/step_entity.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/tree/list_tree_response.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/models/params/season/create_season_param.dart';
import 'package:flutter_base/models/response/object_response.dart';
import 'package:flutter_base/repositories/contract_work_reponsitory.dart';
import 'package:flutter_base/repositories/process_repository.dart';
import 'package:flutter_base/repositories/season_repository.dart';
import 'package:flutter_base/utils/date_utils.dart' as Util;
part 'contract_task_add_state.dart';

class ContractTaskAddingCubit extends Cubit<ContractTaskAddingState> {
  ContractWorkRepositoy contractWorkRepositoy;
 ContractTaskAddingCubit(
      {required this.contractWorkRepositoy})
      : super(ContractTaskAddingState());



  void changeSeasonName(String name) {
    emit(state.copyWith(seasonName: name));
  }

  void changeGarden(GardenEntity value) {
    emit(state.copyWith(gardenEntity: value));
  }
  void changeWork(ContractWorkEntity value){

  }

  void changeStartTime(String startTime) {

    emit(state.copyWith(startTime: startTime));

  }
  void changeEndTime(String endTime) {
    emit(state.copyWith(endTime: endTime));

  }
  void changeTreePlaceQuantity(String treePlaceQuantity){
    emit(state.copyWith(treePlaceQuantityMax: treePlaceQuantity));
  }
}
