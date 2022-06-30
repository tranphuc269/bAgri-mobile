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

  @override
  List<Object?> get props => [
    loadStatus,
    addDescriptionStatus,
    contractTask,
    description,
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
        this.description,
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
    String? description,
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
      description: description ?? this.description,
    );
  }
}