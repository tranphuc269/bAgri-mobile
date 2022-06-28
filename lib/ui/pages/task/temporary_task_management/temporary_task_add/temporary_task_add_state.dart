part of 'temporary_task_add_cubit.dart';

class TemporaryTaskAddState extends Equatable {
  LoadStatus? loadStatus;
  TemporaryTask? temporaryTask;
  String? treePlaceQuantityMax;
  GardenEntity? gardenEntity;
  String? startTime;
  String? name;
  List<DailyTask>? dailyTasks;

  bool get buttonEnabled {
    if (startTime == null || gardenEntity == null)
      return false;
    else
      return true;
  }

  TemporaryTaskAddState(
      {this.loadStatus,
      this.gardenEntity,
      this.treePlaceQuantityMax,
      this.temporaryTask,
      this.startTime,
      this.name,
      this.dailyTasks});

  TemporaryTaskAddState copyWith(
      {LoadStatus? loadStatus,
      GardenEntity? gardenEntity,
      TemporaryTask? temporaryTask,
      LoadStatus? addContractTaskStatus,
      String? treePlaceQuantityMax,
      String? startTime,
      String? name,
      List<DailyTask>? dailyTasks}) {
    return TemporaryTaskAddState(
        loadStatus: loadStatus ?? this.loadStatus,
        gardenEntity: gardenEntity ?? this.gardenEntity,
        treePlaceQuantityMax: treePlaceQuantityMax ?? this.treePlaceQuantityMax,
        name: name ?? this.name,
        startTime: startTime ?? this.startTime,
        dailyTasks: dailyTasks ?? this.dailyTasks);
  }

  @override
  List<Object?> get props =>
      [loadStatus, gardenEntity, temporaryTask, name, dailyTasks];
}
