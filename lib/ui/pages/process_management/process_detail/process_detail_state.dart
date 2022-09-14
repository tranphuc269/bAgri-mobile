part of 'process_detail_cubit.dart';

class ProcessDetailState extends Equatable {
  LoadStatus? loadStatus;
  List<TreeEntity>? trees;

  List<StageEntity>? stages;
  String? name;
  int actionWithStepStatus;

  ProcessDetailState(
      {this.loadStatus,
      this.trees,
      this.stages,

      this.name,
      required this.actionWithStepStatus});

  ProcessDetailState copyWith({
    LoadStatus? loadStatus,
    List<TreeEntity>? trees,

    List<StageEntity>? stages,
    String? name,
    int? actionWithStepStatus,
  }) {
    return ProcessDetailState(
        loadStatus: loadStatus ?? this.loadStatus,
        trees: trees ?? this.trees,
        stages: stages ?? this.stages,

        name: name ?? this.name,
        actionWithStepStatus:
            actionWithStepStatus ?? this.actionWithStepStatus);
  }

  @override
  List<dynamic> get props => [
        loadStatus,
        trees,
        stages,

        name,
        actionWithStepStatus,
      ];
}
