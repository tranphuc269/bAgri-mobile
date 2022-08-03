part of 'temporary_task_update_cubit.dart';

class TemporaryTaskUpdateState extends Equatable {
  LoadStatus? loadStatus;
  TemporaryTask? temporaryTask;
  String? description;
  List<DailyTask>? dailyTasks;
  List<MaterialTask>? materials;
  SeasonEntity? seasonEntity;
  LoadStatus? getSeasonStatus;

  TemporaryTaskUpdateState(
      {this.temporaryTask, this.loadStatus, this.description, this.dailyTasks, this.materials, this.seasonEntity, this.getSeasonStatus});

  TemporaryTaskUpdateState copyWith(
      {LoadStatus? loadStatus,
      TemporaryTask? temporaryTask,
      String? description,
      List<DailyTask>? dailyTasks,
        List<MaterialTask>? materials,
        SeasonEntity? seasonEntity,
        LoadStatus? getSeasonStatus
      }) {
    return TemporaryTaskUpdateState(
        loadStatus: loadStatus ?? this.loadStatus,
        temporaryTask: temporaryTask ?? this.temporaryTask,
        description: description ?? this.description,
        dailyTasks: dailyTasks ?? this.dailyTasks,
        materials: materials ?? this.materials,
    seasonEntity: seasonEntity ?? this.seasonEntity,
    getSeasonStatus: getSeasonStatus?? this.getSeasonStatus);
  }

  @override
  List<Object?> get props =>
      [loadStatus, temporaryTask, description, dailyTasks, materials, seasonEntity, getSeasonStatus];
}
