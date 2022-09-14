part of 'add_process_cubit.dart';

class AddProcessState extends Equatable {
  final String? name;
  final LoadStatus? addProcessStatus;
  final List<TreeEntity>? trees;

  final List<StageEntity>? stages;
  int actionWithStepStatus;
  AddProcessState({
    this.name,
    this.addProcessStatus,
    this.trees,
    this.stages,
    required this.actionWithStepStatus,
  });

  AddProcessState copyWith({
    String? name,
    LoadStatus? addProcessStatus,
    List<TreeEntity>? trees,
    List<StageEntity>? stages,
    int? actionWithStepStatus,
  }) {
    return AddProcessState(
        name: name ?? this.name,
        addProcessStatus: addProcessStatus ?? this.addProcessStatus,
        trees: trees ?? this.trees,
        stages: stages ?? this.stages,
        actionWithStepStatus:
            actionWithStepStatus ?? this.actionWithStepStatus);
  }

  @override
  List<Object?> get props => [
        this.name,
        this.trees,
        this.addProcessStatus,
        this.stages,
        actionWithStepStatus,
      ];
}
