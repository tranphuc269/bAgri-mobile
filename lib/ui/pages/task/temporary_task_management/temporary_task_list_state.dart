part of 'temporary_task_list_cubit.dart';
class TemporaryTaskListState extends Equatable {
  LoadStatus? loadStatus;
  List<TemporaryTask>? temporaryTaskList;

  TemporaryTaskListState({
    this.loadStatus,
    this.temporaryTaskList
});

  TemporaryTaskListState copyWith({
    List<TemporaryTask>? temporaryTaskList,
    // final String? description,
    LoadStatus? loadStatus,
  }) {
    return TemporaryTaskListState(
      temporaryTaskList: temporaryTaskList ?? this.temporaryTaskList,
      // description: description ?? this.description,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }
  @override
  List<dynamic> get props => [
    loadStatus,
    temporaryTaskList
  ];
}