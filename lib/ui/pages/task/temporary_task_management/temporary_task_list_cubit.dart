import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'temporary_task_list_state.dart';

class TemporaryTaskListCubit extends Cubit<TemporaryTaskListState>{
  TemporaryTaskRepository? temporaryTaskRepository;

  TemporaryTaskListCubit({this.temporaryTaskRepository}): super(TemporaryTaskListState());

  Future<void> getListTemporaryTasks(String? seasonId) async{
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      final response = await temporaryTaskRepository!.getListTemporaryTaskBySeason(seasonId: seasonId);
      if (response != null) {
        emit(state.copyWith(
          loadStatus: LoadStatus.SUCCESS,
          temporaryTaskList: response,
        ));
      } else {
        emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      }
      emit(state.copyWith(loadStatus: LoadStatus.SUCCESS));
    } catch (error) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    }
  }

  deleteTemporaryTask(String id) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      final response = await temporaryTaskRepository!.deleteTemporaryTask(id);
      emit(state.copyWith(loadStatus: LoadStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      return;
    }
  }
}