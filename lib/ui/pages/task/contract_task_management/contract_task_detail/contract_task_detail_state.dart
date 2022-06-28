part of 'contract_task_detail_cubit.dart';

class ContractTaskDetailState extends Equatable {
  LoadStatus? loadStatus;
  LoadStatus? addDescriptionStatus;
  LoadStatus? updateContractTaskStatus;
  ContractTask? contractTask;
  LoadStatus? getFinishStatus;
  LoadStatus? addMaterialStatus;
  LoadStatus? finishContractTaskStatus;
  List<MaterialUsedByTask>? materials;

  @override
  List<Object?> get props => [
    loadStatus,
    addDescriptionStatus,
    contractTask,
    updateContractTaskStatus,
    addMaterialStatus,
    finishContractTaskStatus,
    getFinishStatus,
    materials
  ];

  ContractTaskDetailState(
      {this.loadStatus,
        this.addDescriptionStatus,
        this.contractTask,
        this.finishContractTaskStatus,
        this.updateContractTaskStatus,
        this.getFinishStatus,
        this.addMaterialStatus, this.materials});

  ContractTaskDetailState copyWith({
    LoadStatus? loadStatus,
    LoadStatus? addDescriptionStatus,
    LoadStatus? updateContractTaskStatus,
    ContractTask? contractTask,
    LoadStatus? addMaterialStatus,
    LoadStatus? finishContractTaskStatus,
    LoadStatus? getFinishStatus,
    List<MaterialUsedByTask>? materials
  }) {
    return ContractTaskDetailState(
      loadStatus: loadStatus ?? this.loadStatus,
      addDescriptionStatus: addDescriptionStatus ?? this.addDescriptionStatus,
      contractTask: contractTask ?? this.contractTask,
      updateContractTaskStatus: updateContractTaskStatus ?? this.updateContractTaskStatus,
      finishContractTaskStatus: finishContractTaskStatus ?? this.finishContractTaskStatus,
      addMaterialStatus: addMaterialStatus ?? this.addMaterialStatus,
      getFinishStatus: getFinishStatus ?? this.getFinishStatus,
      materials: materials ?? this.materials,
    );
  }
}