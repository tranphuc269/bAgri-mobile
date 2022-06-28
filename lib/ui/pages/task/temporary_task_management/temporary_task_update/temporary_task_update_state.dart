part of 'temporary_task_update_cubit.dart';

class TemporaryTaskUpdateState extends Equatable {
  LoadStatus? loadStatus;
  TemporaryTask? temporaryTask;
  String? description;
  List<DailyTask>? dailyTasks;
  List<MaterialTask>? materials;

  TemporaryTaskUpdateState(
      {this.temporaryTask, this.loadStatus, this.description, this.dailyTasks, this.materials});

  TemporaryTaskUpdateState copyWith(
      {LoadStatus? loadStatus,
      TemporaryTask? temporaryTask,
      String? description,
      List<DailyTask>? dailyTasks,
      List}) {
    return TemporaryTaskUpdateState(
        loadStatus: loadStatus ?? this.loadStatus,
        temporaryTask: temporaryTask ?? this.temporaryTask,
        description: description ?? this.description,
        dailyTasks: dailyTasks ?? this.dailyTasks, materials: materials ?? this.materials);
  }

  @override
  List<Object?> get props =>
      [loadStatus, temporaryTask, description, dailyTasks];
}
