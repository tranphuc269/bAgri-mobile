part of 'contract_task_add_cubit.dart';

class ContractTaskAddingState extends Equatable {
  LoadStatus? loadStatus;
  String? seasonName;
  ContractWorkEntity? contractWorkEntity;
  String? treePlaceQuantityMax;
  GardenEntity? gardenEntity;
  String? startTime;

  String? endTime;
  int? duration;

  bool get buttonEnabled {
    if (seasonName == null ||
        startTime == null ||
        endTime == null ||
        gardenEntity == null)
      return false;
    else if (seasonName!.isEmpty)
      return false;
    else
      return true;
  }

  @override
  List<dynamic> get props => [
    seasonName,
    gardenEntity,
    contractWorkEntity,
    startTime,
    endTime,
    treePlaceQuantityMax,
    loadStatus,
    duration,
  ];

  ContractTaskAddingState resetDuration({
    LoadStatus? loadStatus,
    String? seasonName,
    GardenEntity? gardenEntity,
    ContractWorkEntity? contractWorkEntity,
    String? treePlaceQuantityMax,
    String? startTime,
    String? endTime,
    int? duration,
    ProcessEntity? processDetail,
  }) {
    return ContractTaskAddingState(
      loadStatus: loadStatus ?? this.loadStatus,
      seasonName: seasonName ?? this.seasonName,
      gardenEntity: gardenEntity ?? this.gardenEntity,
      treePlaceQuantityMax: treePlaceQuantityMax ?? this.treePlaceQuantityMax,
      contractWorkEntity: contractWorkEntity ?? this.contractWorkEntity,
      startTime: startTime ?? this.startTime,
      endTime: endTime,
      duration: duration,
    );
  }

  ContractTaskAddingState({
    this.loadStatus,
    this.seasonName,
    this.gardenEntity,
    this.treePlaceQuantityMax,
    this.contractWorkEntity,
    this.startTime,
    this.endTime,
    this.duration,

  });

  ContractTaskAddingState copyWith({
    LoadStatus? loadStatus,
    String? seasonName,
    GardenEntity? gardenEntity,
    ContractWorkEntity? contractWorkEntity,
    String? treePlaceQuantityMax,
    String? startTime,
    String? endTime,
    int? duration,
    ProcessEntity? processDetail,
  }) {
    return ContractTaskAddingState(
        loadStatus: loadStatus ?? this.loadStatus,
        seasonName: seasonName ?? this.seasonName,
        gardenEntity: gardenEntity ?? this.gardenEntity,
        treePlaceQuantityMax: treePlaceQuantityMax ?? this.treePlaceQuantityMax,
        contractWorkEntity: contractWorkEntity ?? this.contractWorkEntity,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        duration: duration ?? this.duration);
  }
}
