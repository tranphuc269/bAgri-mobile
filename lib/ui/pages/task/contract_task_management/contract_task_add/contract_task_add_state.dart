part of 'contract_task_add_cubit.dart';

class ContractTaskAddingState extends Equatable {
  LoadStatus? loadStatus;
  ContractWorkEntity? contractWorkEntity;
  LoadStatus? addContractTaskStatus;
  String? treePlaceQuantityMax;
  GardenEntity? gardenEntity;
  String? startTime;

  bool get buttonEnabled {
    if (startTime == null ||
        gardenEntity == null || contractWorkEntity == null)
      return false;
    else
      return true;
  }

  @override
  List<dynamic> get props => [
    gardenEntity,
    contractWorkEntity,
    addContractTaskStatus,
    startTime,
    treePlaceQuantityMax,
    loadStatus,
  ];

  ContractTaskAddingState resetDuration({
    LoadStatus? loadStatus,
    GardenEntity? gardenEntity,
    ContractWorkEntity? contractWorkEntity,
    LoadStatus? addContractTaskStatus,
    String? treePlaceQuantityMax,
    String? startTime,
  }) {
    return ContractTaskAddingState(
      loadStatus: loadStatus ?? this.loadStatus,
      gardenEntity: gardenEntity ?? this.gardenEntity,
      treePlaceQuantityMax: treePlaceQuantityMax ?? this.treePlaceQuantityMax,
      addContractTaskStatus: addContractTaskStatus ?? this.addContractTaskStatus,
      contractWorkEntity: contractWorkEntity ?? this.contractWorkEntity,
      startTime: startTime ?? this.startTime,
    );
  }

  ContractTaskAddingState({
    this.loadStatus,
    this.gardenEntity,
    this.treePlaceQuantityMax,
    this.addContractTaskStatus,
    this.contractWorkEntity,
    this.startTime,
  });

  ContractTaskAddingState copyWith({
    LoadStatus? loadStatus,
    GardenEntity? gardenEntity,
    ContractWorkEntity? contractWorkEntity,
    LoadStatus? addContractTaskStatus,
    String? treePlaceQuantityMax,
    String? startTime,
  }) {
    return ContractTaskAddingState(
        loadStatus: loadStatus ?? this.loadStatus,
        gardenEntity: gardenEntity ?? this.gardenEntity,
        contractWorkEntity: contractWorkEntity ?? this.contractWorkEntity,
        addContractTaskStatus: addContractTaskStatus ?? this.addContractTaskStatus,
        treePlaceQuantityMax: treePlaceQuantityMax ?? this.treePlaceQuantityMax,
        startTime: startTime ?? this.startTime);
  }
}
