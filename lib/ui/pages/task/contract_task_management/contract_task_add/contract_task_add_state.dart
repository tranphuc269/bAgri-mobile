part of 'contract_task_add_cubit.dart';

class ContractTaskAddingState extends Equatable {
  LoadStatus? loadStatus;
  ContractWorkEntity? contractWorkEntity;
  LoadStatus? addContractTaskStatus;
  String? treePlaceQuantityMax;
  SeasonEntity? seasonEntity;
  String? startTime;

  bool get buttonEnabled {
    if (startTime == null ||
        seasonEntity == null || contractWorkEntity == null)
      return false;
    else
      return true;
  }

  @override
  List<dynamic> get props => [
    seasonEntity,
    contractWorkEntity,
    addContractTaskStatus,
    startTime,
    treePlaceQuantityMax,
    loadStatus,
  ];

  ContractTaskAddingState resetDuration({
    LoadStatus? loadStatus,
    SeasonEntity? seasonEntity,
    ContractWorkEntity? contractWorkEntity,
    LoadStatus? addContractTaskStatus,
    String? treePlaceQuantityMax,
    String? startTime,
  }) {
    return ContractTaskAddingState(
      loadStatus: loadStatus ?? this.loadStatus,
      seasonEntity: seasonEntity ?? this.seasonEntity,
      treePlaceQuantityMax: treePlaceQuantityMax ?? this.treePlaceQuantityMax,
      addContractTaskStatus: addContractTaskStatus ?? this.addContractTaskStatus,
      contractWorkEntity: contractWorkEntity ?? this.contractWorkEntity,
      startTime: startTime ?? this.startTime,
    );
  }

  ContractTaskAddingState({
    this.loadStatus,
    this.seasonEntity,
    this.treePlaceQuantityMax,
    this.addContractTaskStatus,
    this.contractWorkEntity,
    this.startTime,
  });

  ContractTaskAddingState copyWith({
    LoadStatus? loadStatus,
    SeasonEntity? seasonEntity,
    ContractWorkEntity? contractWorkEntity,
    LoadStatus? addContractTaskStatus,
    String? treePlaceQuantityMax,
    String? startTime,
  }) {
    return ContractTaskAddingState(
        loadStatus: loadStatus ?? this.loadStatus,
        seasonEntity: seasonEntity ?? this.seasonEntity,
        contractWorkEntity: contractWorkEntity ?? this.contractWorkEntity,
        addContractTaskStatus: addContractTaskStatus ?? this.addContractTaskStatus,
        treePlaceQuantityMax: treePlaceQuantityMax ?? this.treePlaceQuantityMax,
        startTime: startTime ?? this.startTime);
  }
}
