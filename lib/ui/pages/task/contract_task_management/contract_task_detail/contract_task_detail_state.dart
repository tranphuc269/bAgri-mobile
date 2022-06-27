part of 'contract_task_detail_cubit.dart';

class ContractTaskDetailState extends Equatable {
  LoadStatus? loadStatus;
  LoadStatus? addDescriptionStatus;
  LoadStatus? updateContractTaskStatus;
  ContractTask? contractTask;
  LoadStatus? addMaterialStatus;
  List<MaterialUsedByTask>? materials;

  @override
  List<Object?> get props => [
        loadStatus,
        addDescriptionStatus,
        contractTask,
        updateContractTaskStatus,
        addMaterialStatus,
         materials
      ];

  ContractTaskDetailState(
      {this.loadStatus,
      this.addDescriptionStatus,
      this.contractTask,
      this.updateContractTaskStatus,
        this.addMaterialStatus, this.materials});

  ContractTaskDetailState copyWith({
    LoadStatus? loadStatus,
    LoadStatus? addDescriptionStatus,
    LoadStatus? updateContractTaskStatus,
    ContractTask? contractTask,
    LoadStatus? addMaterialStatus,
    List<MaterialUsedByTask>? materials
  }) {
    return ContractTaskDetailState(
        loadStatus: loadStatus ?? this.loadStatus,
        addDescriptionStatus: addDescriptionStatus ?? this.addDescriptionStatus,
        contractTask: contractTask ?? this.contractTask,
        updateContractTaskStatus: updateContractTaskStatus ?? this.updateContractTaskStatus,
      addMaterialStatus: addMaterialStatus ?? this.addMaterialStatus,
      materials: materials ?? this.materials,
    );
  }
}
