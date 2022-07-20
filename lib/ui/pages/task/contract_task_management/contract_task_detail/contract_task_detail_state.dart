part of 'contract_task_detail_cubit.dart';

class ContractTaskDetailState extends Equatable {
  LoadStatus? loadStatus;
  LoadStatus? addDescriptionStatus;
  LoadStatus? updateContractTaskStatus;
  ContractTask? contractTask;
  LoadStatus? getFinishStatus;
  LoadStatus? addMaterialStatus;
  LoadStatus? finishContractTaskStatus;
  String? description;
  List<MaterialUsedByTask>? materials;
  LoadStatus? getSeasonStatus;
  SeasonEntity? seasonEntity;

  @override
  List<Object?> get props => [
    loadStatus,
    getSeasonStatus,
    addDescriptionStatus,
    contractTask,
    description,
    updateContractTaskStatus,
    addMaterialStatus,
    finishContractTaskStatus,
    getFinishStatus,
    seasonEntity,
    materials
  ];

  ContractTaskDetailState(
      {this.loadStatus,
        this.addDescriptionStatus,
        this.contractTask,
        this.getSeasonStatus,
        this.description,
        this.finishContractTaskStatus,
        this.updateContractTaskStatus,
        this.getFinishStatus,
        this.seasonEntity,
        this.addMaterialStatus, this.materials});

  ContractTaskDetailState copyWith({
    LoadStatus? loadStatus,
    LoadStatus? getSeasonStatus,
    LoadStatus? addDescriptionStatus,
    LoadStatus? updateContractTaskStatus,
    ContractTask? contractTask,
    LoadStatus? addMaterialStatus,
    LoadStatus? finishContractTaskStatus,
    LoadStatus? getFinishStatus,
    String? description,
    SeasonEntity? seasonEntity,
    List<MaterialUsedByTask>? materials
  }) {
    return ContractTaskDetailState(
      loadStatus: loadStatus ?? this.loadStatus,
      addDescriptionStatus: addDescriptionStatus ?? this.addDescriptionStatus,
      getSeasonStatus: getSeasonStatus ?? this.getSeasonStatus,
      contractTask: contractTask ?? this.contractTask,
      updateContractTaskStatus: updateContractTaskStatus ?? this.updateContractTaskStatus,
      finishContractTaskStatus: finishContractTaskStatus ?? this.finishContractTaskStatus,
      addMaterialStatus: addMaterialStatus ?? this.addMaterialStatus,
      getFinishStatus: getFinishStatus ?? this.getFinishStatus,
      materials: materials ?? this.materials,
      description: description ?? this.description,
      seasonEntity: seasonEntity ?? this.seasonEntity
    );
  }
}