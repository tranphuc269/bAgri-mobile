import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/material/material_task.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'temporary_task_update_state.dart';

class TemporaryTaskUpdateCubit extends Cubit<TemporaryTaskUpdateState> {
  TemporaryTaskRepository? temporaryTaskRepository;

  TemporaryTaskUpdateCubit({this.temporaryTaskRepository})
      : super(TemporaryTaskUpdateState());

  Future<void> getTemporaryDetail(String? temporaryId) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      final result =
          await temporaryTaskRepository?.getTemporaryTaskById(temporaryId);

      emit(state.copyWith(
          loadStatus: LoadStatus.SUCCESS,
          temporaryTask: result,
          dailyTasks: result?.dailyTasks /*.data!.season!*/));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }

  addList(String name, String fee, String workerQuantity, String startTime) {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING_MORE));
    List<DailyTask> dailyTasks = state.dailyTasks ?? [];
    dailyTasks.add(DailyTask(
      date: startTime,
      workerQuantity: (int.tryParse(workerQuantity) ?? 0),
      title: name,
      fee: (int.tryParse(fee) ?? 0),
    ));
    List<DailyTask> newList = dailyTasks;
    emit(state.copyWith(
        dailyTasks: newList, loadStatus: LoadStatus.FORMAT_EXTENSION_FILE));
  }

  void createMaterial(int index, MaterialTask value) {
    emit(state.copyWith( loadStatus:LoadStatus.LOADING_MORE));
    List<DailyTask> dailyTasks = state.dailyTasks ?? [];
    if (dailyTasks[index].materials == null) {
      dailyTasks[index].materials = [];
    }
    dailyTasks[index].materials!.add(value);
    List<DailyTask> newList = dailyTasks;
    emit(state.copyWith(dailyTasks: newList, loadStatus: state.loadStatus));
  }

  removeList(int index) {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING_MORE));
    List<DailyTask> dailyTasks = state.dailyTasks ?? [];
    dailyTasks.removeAt(index);
    List<DailyTask> newList = dailyTasks;
    emit(state.copyWith(
        dailyTasks: dailyTasks, loadStatus: LoadStatus.FORMAT_EXTENSION_FILE));
  }

  void removeMaterial(int index, int indexStages) {
    List<DailyTask> dailyTasks = state.dailyTasks ?? [];
    dailyTasks[indexStages].materials?.removeAt(index);
    List<DailyTask> newList = dailyTasks;
    emit(state.copyWith(dailyTasks: newList));
  }

  Future<void> updateTemporaryTask(String temporaryTaskId) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      final temp = TemporaryTask(
        dailyTasks: state.dailyTasks,
        temporaryTaskId: state.temporaryTask?.temporaryTaskId,
        title: state.temporaryTask?.title,
        description: state.temporaryTask?.description,
        season: state.temporaryTask?.season
      );
      var response = temporaryTaskRepository!.updateTemporaryTask(temp, temporaryTaskId);
      if (response != null) {
        emit(state.copyWith(loadStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }
}
