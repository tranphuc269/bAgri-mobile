import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/garden/garden_entity.dart';
import 'package:flutter_base/models/entities/season/season_entity.dart';
import 'package:flutter_base/models/entities/task/temporary_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/repositories/temporary_task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'temporary_task_add_state.dart';
class TemporaryTaskAddCubit extends Cubit<TemporaryTaskAddState>{
  TemporaryTaskRepository? temporaryTaskRepository;

  TemporaryTaskAddCubit({this.temporaryTaskRepository}): super(TemporaryTaskAddState());

  createTemporaryTask(String? seasonId) async{
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try{
      final param = TemporaryTask(
        title: state.name,
        season: seasonId,
        dailyTasks: state.dailyTasks,
      );
      final response = await temporaryTaskRepository!.createTemporaryTask(param);
      if (response != null) {
        emit(state.copyWith(loadStatus: LoadStatus.SUCCESS));
      } else {
        emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      }
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      // showMessageController.sink.add(SnackBarMessage(
      //   message: S.current.error_occurred,
      //   type: SnackBarType.ERROR,
      // ));
      return;
    }
  }

  changeGarden(GardenEntity gardenEntity){
    emit(state.copyWith(gardenEntity: gardenEntity));
  }
  changeSeason(SeasonEntity seasonEntity){
    emit(state.copyWith(seasonEntity: seasonEntity));
  }

  changeName(String name){
    emit(state.copyWith(name:name));
  }
  changeStartTime(String start){
    emit(state.copyWith(startTime: start));
  }
  addList(String name,  String fee, String workerQuantity, String startTime){
    emit(state.copyWith(loadStatus: LoadStatus.LOADING_MORE));
    List<DailyTask> dailyTasks = state.dailyTasks ?? [];
    dailyTasks.add(DailyTask(date:startTime, workerQuantity: (int.tryParse(workerQuantity) ?? 0), title: name, fee: (int.tryParse(fee) ?? 0), ));
    // stages.add(value);
    List<DailyTask> newList = dailyTasks;
    emit(state.copyWith(
        dailyTasks: newList, loadStatus: LoadStatus.FORMAT_EXTENSION_FILE));
  }

  removeList(int index){
    emit(state.copyWith(loadStatus: LoadStatus.LOADING_MORE));
    List<DailyTask> dailyTasks = state.dailyTasks ?? [];
    dailyTasks.removeAt(index);
    List<DailyTask> newList = dailyTasks;
    emit(state.copyWith(
        dailyTasks: newList, loadStatus: LoadStatus.FORMAT_EXTENSION_FILE));
  }

}