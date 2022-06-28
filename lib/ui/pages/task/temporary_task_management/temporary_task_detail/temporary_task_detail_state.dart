part of 'temporary_task_detail_cubit.dart';

class TemporaryTaskDetailState extends Equatable {
  LoadStatus? loadStatus;
  TemporaryTask? temporaryTask;
  String? description;

  TemporaryTaskDetailState({this.temporaryTask, this.loadStatus, this.description});

  TemporaryTaskDetailState copyWith(
      {LoadStatus? loadStatus, TemporaryTask? temporaryTask, String? description}) {
    return TemporaryTaskDetailState(
        loadStatus: loadStatus ?? this.loadStatus,
        temporaryTask: temporaryTask ?? this.temporaryTask,
    description: description ?? this.description);
  }

  @override
  List<Object?> get props => [loadStatus, temporaryTask, description];
}
