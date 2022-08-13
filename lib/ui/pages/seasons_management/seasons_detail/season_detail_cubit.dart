import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/season/stage_season.dart';
import 'package:flutter_base/models/entities/task/contract_task.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/entities/task/work.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/contract_task_responsitory.dart';
import 'package:flutter_base/repositories/season_repository.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'season_detail_state.dart';

class SeasonDetailCubit extends Cubit<SeasonDetailState> {
  SeasonRepository seasonRepository;
  TemporaryTaskRepository temporaryTaskRepository;
  ContractTaskRepository contractTaskRepository;

  SeasonDetailCubit(
      {required this.seasonRepository,
      required this.temporaryTaskRepository,
      required this.contractTaskRepository})
      : super(SeasonDetailState());

  Future<void> endStage(int index, String? phaseId) async{
    // emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      var result =await seasonRepository.endPhase(phaseId!);
      getSeasonDetail(state.season!.seasonId!);
    } catch (e) {
      // emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }

  void endStep(int index, int indexStage) async {
    List<StageSeason> stages = state.season!.process!.stages ?? [];
    try {
      var result = await seasonRepository.endStep(stages[indexStage].stage_id!,
          stages[indexStage].steps![index].step_id!);
      getSeasonDetail(state.season!.seasonId!);
    } catch (e) {
      // emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }

  Future<void> getSeasonDetail(String seasonId) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      SeasonEntity result = await seasonRepository.getSeasonById(seasonId);

      emit(state.copyWith(
          loadStatus: LoadStatus.SUCCESS, season: result /*.data!.season!*/));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }

  Future<bool> updateSeason(String seasonId) async {
    try {
      SeasonEntity param = SeasonEntity(
        name: state.season!.name,
        // garden_id: state.season!.garden!.id,
        process: state.season!.process!,
        tree: state.season!.tree!,
        start_date: state.season!.start_date,
        end_date: state.season!.end_date,
      );
      // SeasonEntity result =
      //     await seasonRepository.updateSeason(seasonId, param);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> endSeason(String seasonId, int turnover) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      var result = await seasonRepository.endSeason(seasonId, turnover);
      emit(state.copyWith(
        loadStatus: LoadStatus.SUCCESS, /*season: result*/ /*.data!.season!*/
      ));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }

  Future<void> getListContractTask(String seasonId) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      var result = await contractTaskRepository.getListContractTaskBySeason(
          seasonId: seasonId);
      emit(state.copyWith(
          loadStatus: LoadStatus.SUCCESS, listContractTask: result));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.SUCCESS));
    }
  }

  Future<void> getListTemporaryTask(String seasonId) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      var result = await temporaryTaskRepository.getListTemporaryTaskBySeason(
          seasonId: seasonId);
      emit(state.copyWith(
          loadStatus: LoadStatus.SUCCESS, listTemporaryTask: result));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.SUCCESS));
    }
  }

  Future<void> calculateFee(String seasonId) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    List<DailyTask> listDailyTask = [];
    List<Work> listWork = [];
    List<MaterialUsedByTask> listMaterial = [];
    int fee = 0;
    int feeWorker = 0;
    int feeMaterial = 0;
    try {
      var listContractTasks = await contractTaskRepository
          .getListContractTaskBySeason(seasonId: seasonId);
      var listTemporaryTasks = await temporaryTaskRepository
          .getListTemporaryTaskBySeason(seasonId: seasonId);
      for (var item in listTemporaryTasks) {
        listDailyTask.addAll(item.dailyTasks ?? []);
        if (item.dailyTasks != null && item.dailyTasks!.length != 0) {
          for (var dailyFee in item.dailyTasks!) {
            feeWorker += dailyFee.fee ?? 0;
            var i = listWork.indexOf(listWork.firstWhere(
                    (element) => element.title == dailyFee.title,
                orElse: () =>Work(
                    title: dailyFee.title,
                    unit: "${dailyFee.workerQuantity.toString()} Người",
                    unitPrice: dailyFee.fee,
                    quantity: dailyFee.workerQuantity)));
            if(i == -1){
              listWork.add(Work(
                  title: dailyFee.title,
                  unit: "${dailyFee.workerQuantity.toString()} Người",
                  unitPrice: dailyFee.fee,
                  quantity: dailyFee.workerQuantity));
            }
            else {
              listWork[i].quantity = ((listWork[i].quantity ?? 0) + (dailyFee.workerQuantity ?? 0));
            }
            if (dailyFee.materials != null && dailyFee.materials!.length != 0) {
              for (var materialFee in dailyFee.materials!) {
                feeMaterial += ((materialFee.quantity ?? 0) *
                    (materialFee.unitPrice ?? 0));
                var index = listMaterial.indexOf(listMaterial.firstWhere(
                    (element) => element.name == materialFee.name,
                    orElse: () => MaterialUsedByTask(
                        name: materialFee.name,
                        unit: materialFee.unit,
                        quantity: materialFee.quantity)));
                if(index == -1){
                  listMaterial.add(MaterialUsedByTask(
                      name: materialFee.name,
                      unit: materialFee.unit,
                      quantity: materialFee.quantity));
                }
                else {
                  listMaterial[index].quantity = (listMaterial[index].quantity?? 0) + (materialFee.quantity ?? 0);
                }
              }
            }
          }
        }
      }
      for (ContractTask item in listContractTasks) {
        if (item.work != null) {
          fee += (item.quantity ?? 0) * (item.work!.unitPrice ?? 0);
          var i = listWork.indexOf(listWork.firstWhere(
                  (element) => element.title == item,
              orElse: () =>Work(
                  title: item.work?.title,
                  unit: item.work?.unit,
                  unitPrice: item.work?.unitPrice,
                  quantity: item.quantity)));
          if(i == -1){
            listWork.add(Work(
                title: item.work?.title,
                unit: item.work?.unit,
                unitPrice: item.work?.unitPrice,
                quantity: item.quantity));
          }
          else {
            listWork[i].quantity = ((listWork[i].quantity ?? 0) + (item.quantity ?? 0));
          }
        }
        if (item.materials != null && item.materials!.length != 0) {
          for (var materialFee in item.materials!) {
            feeMaterial +=
                ((materialFee.quantity ?? 0) * (materialFee.unitPrice ?? 0));
            var index = listMaterial.indexOf(listMaterial.firstWhere(
                    (element) => element.name == materialFee.name,
                orElse: () => MaterialUsedByTask(
                    name: materialFee.name,
                    unit: materialFee.unit,
                    quantity: materialFee.quantity)));
            if(index == -1){
              listMaterial.add( MaterialUsedByTask(
                  name: materialFee.name,
                  unit: materialFee.unit,
                  quantity: materialFee.quantity));
            }
            else {
              listMaterial[index].quantity = (listMaterial[index].quantity?? 0) + (materialFee.quantity ?? 0);
            }
          }
        }
      }
      emit(state.copyWith(
          loadStatus: LoadStatus.SUCCESS,
          fee: fee,
          feeWorker: feeWorker,
          feeMaterial: feeMaterial,
        listMaterial: listMaterial,
        listWork: listWork
      ));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.SUCCESS));
    }
  }

// Future<bool> generateQRCode(String seasonId) async {
//   try {
//     ObjectResponse<QREntity> result =
//         await seasonRepository.generateQRCode(seasonId);
//     emit(state.copyWith(
//         linkQR: result.data!.qr_code_url, linkUrl: result.data!.link));
//     return true;
//   } catch (e) {
//     return false;
//   }
// }
}
