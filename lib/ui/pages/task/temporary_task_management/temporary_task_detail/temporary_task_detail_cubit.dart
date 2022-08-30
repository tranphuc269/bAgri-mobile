import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/season_repository.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'temporary_task_detail_state.dart';

class TemporaryTaskDetailCubit extends Cubit<TemporaryTaskDetailState> {
  TemporaryTaskRepository? temporaryTaskRepository;
  SeasonRepository? seasonRepository;

  TemporaryTaskDetailCubit({this.temporaryTaskRepository, this.seasonRepository})
      : super(TemporaryTaskDetailState());

  Future<void> getTemporaryDetail(String? temporaryId) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      final result =
      await temporaryTaskRepository?.getTemporaryTaskById(temporaryId);
      emit(state.copyWith(
          loadStatus: LoadStatus.SUCCESS,
          temporaryTask: result /*.data!.season!*/));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }

  void changeDescription(String? description) {
    emit(state.copyWith(description: description));
    TemporaryTask temp = state.temporaryTask!;
    temp.description = description;
    emit(state.copyWith(temporaryTask: temp));
  }
  Future<void> getSeasonDetail(String? seasonId) async {
    emit(state.copyWith(getSeasonStatus: LoadStatus.LOADING));
    try {
      SeasonEntity result =
      await seasonRepository!.getSeasonById(seasonId.toString());
      emit(state.copyWith(
          getSeasonStatus: LoadStatus.SUCCESS, seasonEntity: result/*.data!.season!*/));
    } catch (e) {
      emit(state.copyWith(getSeasonStatus: LoadStatus.FAILURE));
    }
  }

  Future<void> updateTemporaryDetail() async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      print(state.temporaryTask!.season);
      final result =
      await temporaryTaskRepository?.updateTemporaryTask(TemporaryTaskUpdate(
          season: state.temporaryTask!.season,
          title: state.temporaryTask!.title,
          description: state.temporaryTask!.description,
          temporaryTaskId: state.temporaryTask!.temporaryTaskId,
          dailyTasks: state.temporaryTask!.dailyTasks,
      ), state.temporaryTask!.temporaryTaskId);
      emit(state.copyWith(
        loadStatus: LoadStatus
            .SUCCESS, /* temporaryTask: result*/ /*.data!.season!*/));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }
}