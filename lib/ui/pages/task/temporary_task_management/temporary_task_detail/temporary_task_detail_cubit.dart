import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_update/temporary_task_update_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

part 'temporary_task_detail_state.dart';
class TemporaryTaskDetailCubit extends Cubit<TemporaryTaskDetailState>{
  TemporaryTaskRepository? temporaryTaskRepository;
  TemporaryTaskDetailCubit({this.temporaryTaskRepository}): super(TemporaryTaskDetailState());

  Future<void> getTemporaryDetail(String? temporaryId) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      final result =
      await temporaryTaskRepository?.getTemporaryTaskById(temporaryId);

      emit(state.copyWith(
          loadStatus: LoadStatus.SUCCESS, temporaryTask: result/*.data!.season!*/));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }

  void changeDescription(String? description){
    emit(state.copyWith(description: description));
    TemporaryTask temp = state.temporaryTask!;
    temp.description = description;
    emit(state.copyWith(temporaryTask: temp));
  }

  Future<void> updateTemporaryDetail() async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      final result =
      await temporaryTaskRepository?.updateTemporaryTask(state.temporaryTask!, state.temporaryTask!.temporaryTaskId);
      emit(state.copyWith(
          loadStatus: LoadStatus.SUCCESS,/* temporaryTask: result*//*.data!.season!*/));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }
}