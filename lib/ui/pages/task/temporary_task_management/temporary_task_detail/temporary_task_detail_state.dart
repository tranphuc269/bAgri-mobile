part of 'temporary_task_detail_cubit.dart';

class TemporaryTaskDetailState extends Equatable {
  LoadStatus? loadStatus;
  TemporaryTask? temporaryTask;
  String? description;
  SeasonEntity? seasonEntity;
  LoadStatus? getSeasonStatus;

  TemporaryTaskDetailState({this.temporaryTask, this.loadStatus, this.description, this.seasonEntity, this.getSeasonStatus});

  TemporaryTaskDetailState copyWith(
      {LoadStatus? loadStatus, TemporaryTask? temporaryTask, String? description, SeasonEntity? seasonEntity, LoadStatus? getSeasonStatus}) {
    return TemporaryTaskDetailState(
        loadStatus: loadStatus ?? this.loadStatus,
        temporaryTask: temporaryTask ?? this.temporaryTask,
    description: description ?? this.description,
    seasonEntity: seasonEntity ?? this.seasonEntity,
    getSeasonStatus: getSeasonStatus ?? this.getSeasonStatus);
  }

  @override
  List<Object?> get props => [loadStatus, temporaryTask, description, seasonEntity, getSeasonStatus];
}
